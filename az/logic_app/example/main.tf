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

module "api_connection" {
  for_each = local.api_connections
  source   = "../../api_connection"

  name                = each.value["name"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  type                = each.value["type"]
  tags                = var.tags
}

module "logic_app" {
  source = "../../logic_app"

  name                = "logic-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  enabled             = false
  parameters          = local.parameters
  workflow_parameters = local.workflow_parameters
  tags                = var.tags
}