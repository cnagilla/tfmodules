resource "random_string" "this" {
  length  = var.random_string_length
  special = false
  upper   = false
}

resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${var.name}-${random_string.this.result}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_app_configuration" "this" {
  name                = "appcfg-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_role_assignment" "app-config-data-owner" {
  scope                = azurerm_app_configuration.this.id
  role_definition_name = "App Configuration Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault" "this" {
  name                       = "kv-${var.name}-${random_string.this.result}"
  location                   = azurerm_resource_group.this.location
  resource_group_name        = azurerm_resource_group.this.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Get",
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover"
    ]
  }
}

resource "azurerm_key_vault_secret" "db_password" {
  name         = "db-password"
  value        = random_password.db_password.result
  key_vault_id = azurerm_key_vault.this.id
}

module "shared_app_conf_key" {
  for_each = local.keys
  source   = "../../app_config_key"

  app_config_id       = azurerm_app_configuration.this.id
  type                = each.value["type"]
  key                 = each.value["key"]
  value               = try(each.value["value"], null)
  vault_key_reference = try(each.value["vault_key_reference"], null)
  tags                = var.tags

  depends_on = [azurerm_role_assignment.app-config-data-owner]
}