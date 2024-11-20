data "azurerm_managed_api" "this" {
  name     = var.type
  location = var.location
}