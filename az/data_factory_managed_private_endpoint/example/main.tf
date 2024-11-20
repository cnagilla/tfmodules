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

resource "azurerm_data_factory" "this" {
  name                            = "df-${var.name}-${random_string.this.result}"
  location                        = azurerm_resource_group.this.location
  resource_group_name             = azurerm_resource_group.this.name
  managed_virtual_network_enabled = true
}

resource "azurerm_storage_account" "this" {
  name                     = "sta${var.name}${random_string.this.result}"
  location                 = azurerm_resource_group.this.location
  resource_group_name      = azurerm_resource_group.this.name
  account_kind             = "BlobStorage"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

module "data_factory_pe" {
  source = "../../data_factory_managed_private_endpoint"

  name               = "dfmpe-${var.name}-${random_string.this.result}"
  data_factory_id    = azurerm_data_factory.this.id
  target_resource_id = azurerm_storage_account.this.id
  subresource_name   = "blob"
}
