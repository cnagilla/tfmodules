resource "azurerm_media_services_account" "this" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  public_network_access_enabled = var.public_network_access_enabled
  storage_authentication_type   = var.storage_authentication_type

  dynamic "storage_account" {
    for_each = var.storage_accounts

    content {
      id         = storage_account.value["id"]
      is_primary = storage_account.value["is_primary"]

      dynamic "managed_identity" {
        for_each = try(storage_account.value["managed_identity"], {})

        content {
          user_assigned_identity_id    = try(managed_identity.value["user_assigned_identity_id"], null)
          use_system_assigned_identity = try(managed_identity.value["use_system_assigned_identity"], false)
        }
      }
    }
  }

  tags = var.tags
}