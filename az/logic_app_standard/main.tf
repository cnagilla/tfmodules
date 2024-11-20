resource "azurerm_logic_app_standard" "this" {
  name                       = var.name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = var.app_service_plan_id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key
  virtual_network_subnet_id  = var.virtual_network_subnet_id
  app_settings               = var.app_settings
  version                    = var.runtime_version
  https_only                 = var.https_only

  dynamic "identity" {
    for_each = var.identities

    content {
      type         = identity.value["type"]
      identity_ids = try(identity.value["identity_ids"], [])
    }
  }

  dynamic "site_config" {
    for_each = var.site_config

    content {
      always_on              = try(site_config.value["always_on"], false)
      vnet_route_all_enabled = try(site_config.value["vnet_route_all_enabled"], false)

      dynamic "cors" {
        for_each = try(site_config.value["cors"], {})

        content {
          allowed_origins     = cors.value["allowed_origins"]
          support_credentials = try(cors.value["support_credentials"], false)
        }
      }
    }
  }

  tags = var.tags
}

module "diagnostic" {
  for_each = var.diagnostic
  source   = "../diagnostic_setting"

  name                           = each.value["name"]
  target_resource_id             = azurerm_logic_app_standard.this.id
  log_analytics_workspace_id     = each.value["log_analytics_workspace_id"]
  log_analytics_destination_type = try(each.value["log_analytics_destination_type"], null)
  log_categories                 = try(each.value["log_categories"], null)
  metric_categories              = try(each.value["metric_categories"], null)
}