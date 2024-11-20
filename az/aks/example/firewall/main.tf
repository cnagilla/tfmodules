resource "random_string" "this" {
  length  = var.random_string_length
  special = false
  upper   = false
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

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "k8s" {
  name                 = "snet-${var.name}-${random_string.this.result}-k8s"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "vm" {
  name                 = "snet-${var.name}-${random_string.this.result}-vm"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "fw" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_route_table" "k8s" {
  name                = "rt-${var.name}-${random_string.this.result}-k8s"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_route" "k8s_fw" {
  name                   = "default_via_fw"
  resource_group_name    = azurerm_resource_group.this.name
  route_table_name       = azurerm_route_table.k8s.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.this.ip_configuration[0].private_ip_address
}

resource "azurerm_subnet_route_table_association" "k8s" {
  subnet_id      = azurerm_subnet.k8s.id
  route_table_id = azurerm_route_table.k8s.id
}

resource "azurerm_public_ip" "bastion" {
  name                = "pip-${var.name}-${random_string.this.result}-bastion"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_public_ip" "fw" {
  name                = "pip-${var.name}-${random_string.this.result}-fw"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_public_ip" "fw_app" {
  name                = "pip-${var.name}-${random_string.this.result}-fwapp"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_public_ip" "jump" {
  name                = "pip-${var.name}-${random_string.this.result}-jump"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  tags                = var.tags
}

resource "azurerm_bastion_host" "this" {
  name                = "bas-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                 = "ifcfg-${var.name}-${random_string.this.result}-bas"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }

  tags = var.tags
}

resource "azurerm_network_interface" "jump" {
  name                = "nic-${var.name}${random_string.this.result}jump"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "ifcfg-${var.name}-${random_string.this.result}-jump"
    subnet_id                     = azurerm_subnet.vm.id
    public_ip_address_id          = azurerm_public_ip.jump.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "jump" {
  name                  = "vm${var.name}${random_string.this.result}jump"
  location              = azurerm_resource_group.this.location
  resource_group_name   = azurerm_resource_group.this.name
  size                  = "Standard_DS2_v2"
  admin_username        = local.linux_profile.default.admin_username
  network_interface_ids = [azurerm_network_interface.jump.id]
  user_data             = base64encode(data.template_file.userdata.rendered)

  admin_ssh_key {
    username   = local.linux_profile.default.admin_username
    public_key = local.linux_profile.default.admin_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  tags = var.tags
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = "log-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

resource "azurerm_firewall_policy" "this" {
  name                = "fwpol-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  dns {
    proxy_enabled = true
  }
}

resource "azurerm_firewall" "this" {
  name                = "fw-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  firewall_policy_id  = azurerm_firewall_policy.this.id

  ip_configuration {
    name                 = "ipconf-${var.name}-${random_string.this.result}-fw"
    subnet_id            = azurerm_subnet.fw.id
    public_ip_address_id = azurerm_public_ip.fw.id
  }

  ip_configuration {
    name                 = "ipconf-${var.name}-${random_string.this.result}-fwapp"
    public_ip_address_id = azurerm_public_ip.fw_app.id
  }

  tags = var.tags
}

resource "azurerm_firewall_policy_rule_collection_group" "before_aks" {
  name               = "fwpolrcg-${var.name}-${random_string.this.result}-pre-aks"
  firewall_policy_id = azurerm_firewall_policy.this.id
  priority           = 100

  application_rule_collection {
    name     = "fwpolapprc-${var.name}-${random_string.this.result}"
    priority = 300
    action   = "Allow"

    rule {
      name        = "AllowWebAks"
      description = "Allow HTTP and HTTPs"

      protocols {
        type = "Http"
        port = 80
      }

      protocols {
        type = "Https"
        port = 443
      }
      source_addresses      = ["*"]
      destination_fqdn_tags = ["AzureKubernetesService"]
    }

    rule {
      name        = "AllowAllWeb"
      description = "Allow HTTP and HTTPs"

      protocols {
        type = "Http"
        port = 80
      }

      protocols {
        type = "Https"
        port = 443
      }

      source_addresses  = ["*"]
      destination_fqdns = ["*"]
    }
  }

  network_rule_collection {
    name     = "fwpolnetrc-${var.name}-${random_string.this.result}"
    priority = 200
    action   = "Allow"

    rule {
      name                  = "Allow_Aks_Api_Udp"
      protocols             = ["UDP"]
      source_addresses      = ["*"]
      destination_addresses = ["AzureCloud.${var.location}"]
      destination_ports     = ["1194"]
    }

    rule {
      name                  = "Allow_Aks_Api_Tcp"
      protocols             = ["TCP"]
      source_addresses      = ["*"]
      destination_addresses = ["AzureCloud.${var.location}"]
      destination_ports     = ["9000"]
    }

    rule {
      name              = "Allow_Aks_Ntp"
      protocols         = ["UDP"]
      source_addresses  = ["*"]
      destination_fqdns = ["ntp.ubuntu.com"]
      destination_ports = ["123"]
    }
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "after_aks" {
  name               = "fwpolrcg-${var.name}-${random_string.this.result}-post-aks"
  firewall_policy_id = azurerm_firewall_policy.this.id
  priority           = 101

  network_rule_collection {
    name     = "fwpolnetrc-${var.name}-${random_string.this.result}"
    priority = 100
    action   = "Allow"

    rule {
      name              = "Allow_Aks_Api_Https"
      protocols         = ["TCP"]
      source_addresses  = ["*"]
      destination_fqdns = [replace(split(":", module.aks.kube_config.0.host)[1], "/", "")]
      destination_ports = ["443"]
    }
  }
}

module "aks" {
  source = "../../../aks"

  name                      = "aks-${var.name}-${random_string.this.result}"
  location                  = azurerm_resource_group.this.location
  resource_group_name       = azurerm_resource_group.this.name
  dns_prefix                = "${var.name}-${random_string.this.result}"
  kubernetes_version        = local.k8s_version
  private_cluster_enabled   = false
  sku_tier                  = "Free"
  enable_rbac               = false
  node_pool                 = local.node_pool
  oms_agent                 = local.oms_agent
  network_profile           = local.network_profile
  linux_profile             = local.linux_profile
  identity                  = local.identity
  api_server_access_profile = local.api_server_access_profile
  tags                      = var.tags

  depends_on = [azurerm_firewall_policy_rule_collection_group.before_aks, azurerm_route.k8s_fw]
}