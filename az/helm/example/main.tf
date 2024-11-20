resource "random_password" "argocd" {
  length  = 16
  special = true
  lower   = true
  upper   = true
  numeric = true
}

resource "random_string" "this" {
  length  = var.random_string_length
  special = false
  upper   = false
}

resource "null_resource" "argocd_admin_password" {
  triggers = {
    orig = random_password.argocd.result
    pw   = bcrypt(random_password.argocd.result)
  }

  lifecycle {
    ignore_changes = [triggers["pw"]]
  }
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${var.name}-${random_string.this.result}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "this" {
  name                = "vnet-${var.name}-${random_string.this.result}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags
}

resource "azurerm_subnet" "k8s" {
  name                 = "snet-${var.name}-${random_string.this.result}-k8s"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = "log-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

resource "azurerm_kubernetes_cluster" "this" {
  name                 = "aks-${var.name}-${random_string.this.result}"
  location             = azurerm_resource_group.this.location
  resource_group_name  = azurerm_resource_group.this.name
  dns_prefix           = "${var.name}-${random_string.this.result}"
  kubernetes_version   = local.k8s_version
  azure_policy_enabled = true

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
  }

  microsoft_defender {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
  }

  network_profile {
    network_plugin = "azure"
    service_cidr   = "10.1.0.0/16"
    dns_service_ip = "10.1.0.10"
  }

  default_node_pool {
    name                        = "default"
    node_count                  = 1
    vm_size                     = "Standard_D2_v2"
    vnet_subnet_id              = azurerm_subnet.k8s.id
    max_pods                    = 60
    temporary_name_for_rotation = "test"
  }

  identity {
    type = "SystemAssigned"
  }

  linux_profile {
    admin_username = local.ssh_user

    ssh_key {
      key_data = local.ssh_public_key
    }
  }

  tags = var.tags
}

resource "azurerm_role_assignment" "k8s-subnet-admin" {
  scope                = azurerm_subnet.k8s.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.this.identity.0.principal_id
}

module "argocd" {
  source = "../../helm"

  name             = "argocd"
  namespace        = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  chart_version    = "5.36.7"
  create_namespace = true
  values           = local.values.argocd

  depends_on = [azurerm_kubernetes_cluster.this, module.nginx-ingress]
}

module "nginx-ingress" {
  source = "../../helm"

  name             = "ingress-nginx"
  namespace        = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  chart_version    = "4.7.0"
  create_namespace = true
  values           = local.values.nginx-internal
  timeout_seconds  = 300

  depends_on = [azurerm_role_assignment.k8s-subnet-admin]
}