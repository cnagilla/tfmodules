resource "azurerm_api_management_logger" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  api_management_name = var.api_management_name
  resource_id         = var.app_insights_id

  application_insights {
    instrumentation_key = var.app_insights_instrumentation_key
  }
}