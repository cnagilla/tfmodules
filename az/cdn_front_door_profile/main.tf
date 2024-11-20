resource "azurerm_cdn_frontdoor_profile" "this" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  sku_name                 = var.sku_name
  response_timeout_seconds = var.response_timeout_seconds
  tags                     = var.tags
}

module "diagnostic" {
  for_each = var.diagnostic
  source   = "../diagnostic_setting"

  name                           = each.value["name"]
  target_resource_id             = azurerm_cdn_frontdoor_profile.this.id
  log_analytics_workspace_id     = each.value["log_analytics_workspace_id"]
  log_categories                 = each.value["log_categories"]
  log_analytics_destination_type = try(each.value["log_analytics_destination_type"], null)
}