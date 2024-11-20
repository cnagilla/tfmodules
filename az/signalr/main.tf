resource "random_string" "this" {
  length  = var.random_string_length
  special = false
  upper   = false
}

resource "azurerm_signalr_service" "this" {
  name                                     = "${var.name_prefix}-${random_string.this.result}"
  location                                 = var.location
  resource_group_name                      = var.resource_group_name
  public_network_access_enabled            = var.public_network_access_enabled
  connectivity_logs_enabled                = var.connectivity_logs_enabled
  serverless_connection_timeout_in_seconds = var.serverless_connection_timeout_in_seconds
  service_mode                             = var.service_mode

  sku {
    name     = var.sku_name
    capacity = var.sku_capacity
  }

  tags = var.tags
}