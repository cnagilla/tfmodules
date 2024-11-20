resource "random_string" "this" {
  length  = var.random_string_length
  special = false
  upper   = false
}

resource "azurerm_mssql_managed_instance_failover_group" "this" {
  name                                      = "${var.name_prefix}-${random_string.this.result}"
  location                                  = var.location
  managed_instance_id                       = var.managed_instance_id
  partner_managed_instance_id               = var.partner_managed_instance_id
  readonly_endpoint_failover_policy_enabled = var.readonly_endpoint_failover_policy_enabled

  read_write_endpoint_failover_policy {
    mode          = var.failover_mode
    grace_minutes = var.grace_period
  }
}