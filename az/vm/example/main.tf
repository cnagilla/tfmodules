resource "random_string" "this" {
  length  = var.random_string_length
  special = false
  upper   = false
}

resource "random_password" "windows" {
  length  = 16
  lower   = true
  upper   = true
  numeric = true
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

resource "azurerm_subnet" "vm" {
  name                 = "snet-${var.name}-${random_string.this.result}-vm"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "bastion" {
  name                = "pip-${var.name}-${random_string.this.result}-bastion"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_bastion_host" "this" {
  name                = "bas-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                 = "ipconf-${var.name}-${random_string.this.result}-bas"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }

  tags = var.tags
}

module "vm" {
  for_each = local.virtual_machines
  source   = "../../vm"

  name                = each.value["name"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  os_family           = each.value["os_family"]
  admin_username      = each.value["admin_username"]
  admin_password      = try(each.value["admin_password"], null)
  admin_public_key    = try(each.value["admin_public_key"], null)
  disk                = each.value["disk"]
  image               = each.value["image"]
  nic                 = each.value["nic"]
  tags                = var.tags
}