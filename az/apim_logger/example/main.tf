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

resource "azurerm_application_insights" "this" {
  name                = "appins-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  application_type    = "other"
  tags                = var.tags
}

resource "azurerm_api_management" "this" {
  name                = "apim-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  publisher_email     = "devops@example.com"
  publisher_name      = "DevOps"
  sku_name            = "Developer_1"
  tags                = var.tags
}

module "apim_logger" {
  source = "../../apim_logger"

  name                             = "apimlog-${var.name}-${random_string.this.result}"
  resource_group_name              = azurerm_resource_group.this.name
  api_management_name              = azurerm_api_management.this.name
  app_insights_id                  = azurerm_application_insights.this.id
  app_insights_instrumentation_key = azurerm_application_insights.this.instrumentation_key
}