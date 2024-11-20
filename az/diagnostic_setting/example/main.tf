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

resource "azurerm_log_analytics_workspace" "this" {
  name                = "log-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

resource "azurerm_cdn_frontdoor_profile" "this" {
  name                = "fd-${var.name}-${random_string.this.result}"
  resource_group_name = azurerm_resource_group.this.name
  sku_name            = "Standard_AzureFrontDoor"
  tags                = var.tags
}

resource "azurerm_service_plan" "this" {
  name                = "asp-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_app_configuration" "this" {
  name                = "appcfg-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

module "diagnostic" {
  for_each = local.diagnostic
  source   = "../../diagnostic_setting"

  name                           = each.value["name"]
  target_resource_id             = each.value["target_resource_id"]
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.this.id
  log_analytics_destination_type = try(each.value["log_analytics_destination_type"], null)
  log_categories                 = try(each.value["log_categories"], {})
  metric_categories              = try(each.value["metric_categories"], {})
}