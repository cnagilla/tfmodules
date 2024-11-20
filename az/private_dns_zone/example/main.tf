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

resource "azurerm_virtual_network" "app" {
  name                = "vnet-${var.name}-${random_string.this.result}-app"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

module "dns_zone" {
  source = "../../private_dns_zone"

  name                = "${var.name}-${random_string.this.result}.com"
  resource_group_name = azurerm_resource_group.this.name
  linked_networks     = local.linked_networks
  a_records           = local.a_records
  cname_records       = local.cname_records
  tags                = var.tags
}