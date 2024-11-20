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

module "signalr" {
  source = "../../signalr"

  name_prefix                   = "sigr-${var.name}-${random_string.this.result}"
  location                      = azurerm_resource_group.this.location
  resource_group_name           = azurerm_resource_group.this.name
  public_network_access_enabled = false
  connectivity_logs_enabled     = true
  sku_capacity                  = 2
  sku_name                      = "Standard_S1"
  service_mode                  = "Serverless"
  tags                          = var.tags
}
