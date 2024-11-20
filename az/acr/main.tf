resource "random_string" "this" {
  length  = var.random_string_length
  special = false
  upper   = false
}

resource "azurerm_container_registry" "this" {
  name                          = "${var.name_prefix}${random_string.this.result}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku                           = var.sku
  admin_enabled                 = var.admin_enabled
  public_network_access_enabled = var.public_network_access_enabled

  dynamic "georeplications" {
    for_each = var.georeplications
    iterator = geo

    content {
      location                  = geo.value["location"]
      regional_endpoint_enabled = try(geo.value["regional_endpoint_enabled"], false)
      zone_redundancy_enabled   = try(geo.value["zone_redundancy_enabled"], false)
      tags                      = var.tags
    }
  }

  tags = var.tags
}
