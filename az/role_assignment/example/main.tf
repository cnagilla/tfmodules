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

resource "azurerm_app_configuration" "this" {
  name                = "appcfg-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

module "role_assignment" {
  source = "../../role_assignment"

  scope                = azurerm_app_configuration.this.id
  principal_id         = data.azurerm_client_config.current.object_id
  role_definition_name = "App Configuration Data Reader"
}