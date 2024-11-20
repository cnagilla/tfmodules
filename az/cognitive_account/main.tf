resource "random_string" "this" {
  length  = var.random_string_length
  special = false
  upper   = false
}

resource "azurerm_cognitive_account" "this" {
  name                       = "${var.name_prefix}-${random_string.this.result}"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  kind                       = var.kind
  sku_name                   = var.sku_name
  custom_subdomain_name      = var.custom_subdomain_name
  dynamic_throttling_enabled = var.dynamic_throttling_enabled
  tags                       = var.tags
}