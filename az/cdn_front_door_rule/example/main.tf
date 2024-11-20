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

module "front_door_rules" {
  for_each = local.rule_sets
  source   = "../../cdn_front_door_rule"

  rule_set_name            = each.value["name"]
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id
  rules                    = each.value["rules"]
}