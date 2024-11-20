resource "random_string" "this" {
  count = var.use_random_name ? 1 : 0

  length  = var.random_string_length
  special = false
  upper   = false
}

resource "random_password" "this" {
  count = var.sql_administrator_login_password == "" ? 1 : 0

  length  = var.random_password_length
  special = true
  lower   = true
  upper   = true
  numeric = true
}

resource "azurerm_synapse_workspace" "this" {
  name                                 = local.name
  resource_group_name                  = var.resource_group_name
  location                             = var.location
  storage_data_lake_gen2_filesystem_id = var.storage_data_lake_gen2_filesystem_id
  sql_administrator_login              = var.sql_administrator_login
  sql_administrator_login_password     = local.sql_administrator_login_password

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}