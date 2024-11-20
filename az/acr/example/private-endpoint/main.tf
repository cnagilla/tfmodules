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

resource "azurerm_subnet" "this" {
  name                 = "snet-${var.name}-${random_string.this.result}-k8s"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_private_dns_zone" "this" {
  name                = "privatelink.azurecr.io"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_private_endpoint" "this" {
  name                = "pep-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = azurerm_subnet.this.id
  tags                = var.tags

  private_dns_zone_group {
    name                 = "dz-${var.name}-${random_string.this.result}-acr"
    private_dns_zone_ids = [azurerm_private_dns_zone.this.id]
  }

  private_service_connection {
    name                           = var.name
    is_manual_connection           = false
    private_connection_resource_id = module.acr.id
    subresource_names              = ["registry"]
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                  = azurerm_virtual_network.this.name
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = azurerm_virtual_network.this.id
}

module "acr" {
  source = "../../../acr"

  name_prefix                   = "acr${var.name}${random_string.this.result}"
  location                      = azurerm_resource_group.this.location
  resource_group_name           = azurerm_resource_group.this.name
  sku                           = "Premium"
  public_network_access_enabled = false
  tags                          = var.tags
}