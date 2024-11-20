resource "azurerm_api_connection" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  managed_api_id      = data.azurerm_managed_api.this.id
  display_name        = var.display_name == "" ? var.name : var.display_name
  tags                = var.tags

  lifecycle {
    ignore_changes = [parameter_values]
  }
}