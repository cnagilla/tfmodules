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

resource "azurerm_public_ip" "bastion" {
  name                = "pip-${var.name}-${random_string.this.result}-bastion"
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

module "aks" {
  source = "../../../aks"

  name                            = "aks-${var.name}-${random_string.this.result}"
  location                        = azurerm_resource_group.this.location
  resource_group_name             = azurerm_resource_group.this.name
  dns_prefix                      = "${var.name}-${random_string.this.result}"
  kubernetes_version              = local.k8s_version
  private_cluster_enabled         = false
  sku_tier                        = "Free"
  enable_rbac                     = false
  node_pool                       = local.node_pool
  oms_agent                       = local.oms_agent
  network_profile                 = local.network_profile
  linux_profile                   = local.linux_profile
  identity                        = local.identity
  api_server_access_profile       = local.api_server_access_profile
  maintenance_window_auto_upgrade = local.maintenance_window_auto_upgrade
  tags                            = var.tags
}