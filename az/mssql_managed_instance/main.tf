resource "random_string" "this" {
  length  = var.random_string_length
  special = false
  upper   = false
}

resource "random_password" "this" {
  length  = 32
  special = true
  lower   = true
  upper   = true
  numeric = true
}

resource "azurerm_mssql_managed_instance" "this" {
  name                         = "${var.name_prefix}-${random_string.this.result}"
  location                     = var.location
  resource_group_name          = var.resource_group_name
  license_type                 = var.license_type
  proxy_override               = var.proxy_override
  sku_name                     = var.sku_name
  storage_size_in_gb           = var.storage_size_in_gb
  subnet_id                    = var.subnet_id
  vcores                       = var.vcores
  administrator_login          = var.admin_login
  administrator_login_password = var.admin_password != "" ? var.admin_password : random_password.this.result
  public_data_endpoint_enabled = var.public_data_endpoint_enabled
  dns_zone_partner_id          = var.dns_zone_partner_id
  tags                         = var.tags

  dynamic "identity" {
    for_each = var.identity

    content {
      type = identity.value["type"]
    }
  }
  # This is required to prevent instance to be recreated when we use failover groups
  lifecycle {
    ignore_changes = [
      dns_zone_partner_id,
    ]
  }

}

resource "azurerm_mssql_managed_database" "this" {
  for_each = var.databases

  name                = try(each.value["name"], "${var.databases_name_prefix}-${each.key}")
  managed_instance_id = azurerm_mssql_managed_instance.this.id
}

module "diagnostic" {
  for_each = var.diagnostic
  source   = "../diagnostic_setting"

  name                           = each.value["name"]
  target_resource_id             = azurerm_mssql_managed_instance.this.id
  log_analytics_workspace_id     = each.value["log_analytics_workspace_id"]
  log_analytics_destination_type = null
  log_categories                 = each.value["log_categories"]
}