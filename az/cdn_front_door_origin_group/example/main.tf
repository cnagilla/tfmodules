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

resource "azurerm_cdn_frontdoor_profile" "this" {
  name                = "fd-${var.name}-${random_string.this.result}"
  resource_group_name = azurerm_resource_group.this.name
  sku_name            = "Standard_AzureFrontDoor"
  tags                = var.tags
}

module "front_door_origin_group" {
  source = "../../cdn_front_door_origin_group"

  name                                                      = local.origin_group.name
  cdn_frontdoor_profile_id                                  = azurerm_cdn_frontdoor_profile.this.id
  lb                                                        = local.origin_group.load_balancing
  health_probe                                              = local.origin_group.health_probe
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = local.origin_group.restore_traffic_time_to_healed_or_new_endpoint_in_minutes
}