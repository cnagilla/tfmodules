resource "random_string" "this" {
  length  = var.random_string_length
  special = false
  upper   = false
}

resource "azurerm_storage_account" "this" {
  name                          = "${var.name_prefix}${random_string.this.result}"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  account_tier                  = var.account_tier
  account_replication_type      = var.account_replication_type
  public_network_access_enabled = var.public_access
  is_hns_enabled                = var.is_hns_enabled
  min_tls_version               = var.min_tls_version
  enable_https_traffic_only     = var.enable_https_traffic_only

  dynamic "network_rules" {
    for_each = var.network_rules

    content {
      default_action             = network_rules.value["default_action"]
      ip_rules                   = try(network_rules.value["ip_rules"], null)
      virtual_network_subnet_ids = try(network_rules.value["virtual_network_subnet_ids"], null)
    }
  }

  dynamic "identity" {
    for_each = var.identities

    content {
      type         = identity.value["type"]
      identity_ids = try(identity.value["identity_ids"], null)
    }
  }

  tags = var.tags
}

resource "azurerm_storage_container" "this" {
  for_each = var.storage_containers

  name                  = try(each.value["name"], "${var.containers_name_prefix}-${each.key}")
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = each.value["access_type"]
  metadata              = try(each.value["metadata"], null)
}

resource "azurerm_storage_share" "this" {
  for_each = var.storage_shares

  name                 = try(each.value["name"], "${var.shares_name_prefix}-${each.key}")
  storage_account_name = azurerm_storage_account.this.name
  quota                = each.value["quota"]
}

module "diagnostic" {
  for_each = var.diagnostic
  source   = "../diagnostic_setting"

  name                           = each.value["name"]
  target_resource_id             = azurerm_storage_account.this.id
  log_analytics_workspace_id     = each.value["log_analytics_workspace_id"]
  log_analytics_destination_type = null
  metric_categories              = each.value["metric_categories"]
}