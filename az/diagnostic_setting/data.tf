data "azurerm_monitor_diagnostic_categories" "this" {
  resource_id = var.target_resource_id
}