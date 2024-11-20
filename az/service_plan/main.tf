resource "azurerm_service_plan" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = var.os_type
  sku_name            = var.sku_name
  tags                = var.tags
}

module "diagnostic" {
  for_each = var.diagnostic
  source   = "../diagnostic_setting"

  name                           = each.value["name"]
  target_resource_id             = azurerm_service_plan.this.id
  log_analytics_workspace_id     = each.value["log_analytics_workspace_id"]
  log_analytics_destination_type = null
  metric_categories              = each.value["metric_categories"]
}