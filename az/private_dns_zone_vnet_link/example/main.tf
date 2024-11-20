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

resource "azurerm_private_dns_zone" "this" {
  name                = "${var.name}-${random_string.this.result}.com"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_virtual_network" "app" {
  name                = "vnet-${var.name}-${random_string.this.result}-app"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

module "vnet_link" {
  source = "../../private_dns_zone_vnet_link"

  name                  = azurerm_virtual_network.app.name
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = azurerm_virtual_network.app.id
  tags                  = var.tags
}