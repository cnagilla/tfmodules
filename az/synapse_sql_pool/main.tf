resource "azurerm_synapse_sql_pool" "this" {
  name                 = var.name
  synapse_workspace_id = var.synapse_workspace_id
  sku_name             = var.sku_name
  create_mode          = var.create_mode
  tags                 = var.tags
}