resource "random_string" "this" {
  length  = var.random_string_length
  special = false
  upper   = false
}

resource "azurerm_app_configuration" "this" {
  name                  = "${var.name_prefix}-${random_string.this.result}"
  location              = var.location
  resource_group_name   = var.resource_group_name
  sku                   = var.sku
  public_network_access = var.public_network_access
  tags                  = var.tags
}

module "diagnostic" {
  for_each = var.diagnostic
  source   = "../diagnostic_setting"

  name                           = each.value["name"]
  target_resource_id             = azurerm_app_configuration.this.id
  log_analytics_workspace_id     = each.value["log_analytics_workspace_id"]
  log_analytics_destination_type = null
  log_categories                 = each.value["log_categories"]
}