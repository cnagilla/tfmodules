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
  tags                = var.tags
}

resource "azurerm_virtual_network" "db" {
  name                = "vnet-${var.name}-${random_string.this.result}-db"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags
}

module "vnet_peer_app_to_db" {
  source = "../../vnet_peering"

  name                         = "vnetpc-${var.name}-${random_string.this.result}-to-db"
  resource_group_name          = azurerm_resource_group.this.name
  virtual_network_name         = azurerm_virtual_network.app.name
  remote_virtual_network_id    = azurerm_virtual_network.db.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

module "vnet_peer_db_to_app" {
  source = "../../vnet_peering"

  name                         = "vnetpc-${var.name}-${random_string.this.result}-to-app"
  resource_group_name          = azurerm_resource_group.this.name
  virtual_network_name         = azurerm_virtual_network.db.name
  remote_virtual_network_id    = azurerm_virtual_network.app.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}