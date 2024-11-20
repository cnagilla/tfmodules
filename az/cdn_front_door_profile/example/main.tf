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

module "front_door_profile" {
  source = "../../cdn_front_door_profile"

  name                     = "fd-${var.name}-${random_string.this.result}"
  resource_group_name      = azurerm_resource_group.this.name
  sku_name                 = "Standard_AzureFrontDoor"
  response_timeout_seconds = 180
  diagnostic               = local.diagnostic
  tags                     = var.tags
}