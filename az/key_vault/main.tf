resource "random_string" "this" {
  length  = var.random_string_length
  special = false
  upper   = false
}

resource "azurerm_key_vault" "this" {
  name                      = "${var.name_prefix}-${random_string.this.result}"
  location                  = var.location
  resource_group_name       = var.resource_group_name
  tenant_id                 = var.tenant_id
  sku_name                  = var.sku_name
  enable_rbac_authorization = var.enable_rbac_authorization

  dynamic "network_acls" {
    for_each = var.network_acls
    iterator = acl

    content {
      bypass                     = acl.value["bypass"]
      default_action             = acl.value["default_action"]
      ip_rules                   = try(acl.value["ip_rules"], null)
      virtual_network_subnet_ids = try(acl.value["virtual_network_subnet_ids"], null)
    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      network_acls[0].virtual_network_subnet_ids
    ]
  }
}

resource "azurerm_key_vault_access_policy" "this" {
  for_each = var.access_policies

  key_vault_id            = azurerm_key_vault.this.id
  tenant_id               = var.tenant_id
  object_id               = each.value["object_id"]
  key_permissions         = try(each.value["key_permissions"], null)
  secret_permissions      = try(each.value["secret_permissions"], null)
  certificate_permissions = try(each.value["certificate_permissions"], null)
  storage_permissions     = try(each.value["storage_permissions"], null)
}

module "diagnostic" {
  for_each = var.diagnostic
  source   = "../diagnostic_setting"

  name                           = each.value["name"]
  target_resource_id             = azurerm_key_vault.this.id
  log_analytics_workspace_id     = each.value["log_analytics_workspace_id"]
  log_analytics_destination_type = try(each.value["log_analytics_destination_type"], null)
  log_categories                 = each.value["log_categories"]
}