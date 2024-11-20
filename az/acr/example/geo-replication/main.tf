resource "random_string" "this" {
  length  = var.random_string_length
  special = false
  upper   = false
}

resource "azurerm_resource_group" "this" {
  for_each = local.locations

  name     = "rg-${var.name}-${each.key}-${random_string.this.result}"
  location = each.value
  tags     = var.tags
}

resource "azurerm_virtual_network" "this" {
  for_each = local.vnet

  name                = "vnet-${var.name}-${each.key}-${random_string.this.result}"
  address_space       = each.value["cidr"]
  location            = azurerm_resource_group.this[each.key].location
  resource_group_name = azurerm_resource_group.this[each.key].name
  tags                = var.tags
}

resource "azurerm_subnet" "this" {
  for_each = local.vnet

  name                 = "snet-${var.name}-pep-${random_string.this.result}"
  resource_group_name  = azurerm_resource_group.this[each.key].name
  virtual_network_name = azurerm_virtual_network.this[each.key].name
  address_prefixes     = each.value["subnet"]
}

resource "azurerm_private_dns_zone" "this" {
  for_each = local.locations

  name                = "privatelink.azurecr.io"
  resource_group_name = azurerm_resource_group.this[each.key].name
}

resource "azurerm_private_endpoint" "this" {
  for_each = local.locations

  name                = "pep-${var.name}-${each.key}-${random_string.this.result}"
  location            = azurerm_resource_group.this[each.key].location
  resource_group_name = azurerm_resource_group.this[each.key].name
  subnet_id           = azurerm_subnet.this[each.key].id
  tags                = var.tags

  private_dns_zone_group {
    name                 = "dz-${var.name}-${each.key}-${random_string.this.result}-acr"
    private_dns_zone_ids = [azurerm_private_dns_zone.this[each.key].id]
  }

  private_service_connection {
    name                           = "pep-${var.name}-${each.key}-${random_string.this.result}"
    is_manual_connection           = false
    private_connection_resource_id = module.acr.id
    subresource_names              = ["registry"]
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each = local.locations

  name                  = azurerm_virtual_network.this[each.key].name
  resource_group_name   = azurerm_resource_group.this[each.key].name
  private_dns_zone_name = azurerm_private_dns_zone.this[each.key].name
  virtual_network_id    = azurerm_virtual_network.this[each.key].id
}

module "acr" {
  source = "../../../acr"

  name_prefix                   = "acr${var.name}${random_string.this.result}"
  location                      = azurerm_resource_group.this["cus"].location
  resource_group_name           = azurerm_resource_group.this["cus"].name
  sku                           = "Premium"
  public_network_access_enabled = false
  georeplications               = local.georeplications
  tags                          = var.tags
}