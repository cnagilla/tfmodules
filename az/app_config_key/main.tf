resource "azurerm_app_configuration_key" "this" {
  configuration_store_id = var.app_config_id
  key                    = var.key
  label                  = var.label
  value                  = var.value
  type                   = var.type
  vault_key_reference    = var.vault_key_reference
  tags                   = var.tags
}