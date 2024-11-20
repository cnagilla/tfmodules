resource "azurerm_search_service" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  semantic_search_sku = var.semantic_search_sku
  replica_count       = var.replica_count
  tags                = var.tags
}