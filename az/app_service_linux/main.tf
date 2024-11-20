resource "azurerm_linux_web_app" "this" {
  name                      = var.name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  service_plan_id           = var.service_plan_id
  virtual_network_subnet_id = var.virtual_network_subnet_id
  app_settings              = var.app_settings

  dynamic "identity" {
    for_each = var.identities

    content {
      type         = identity.value["type"]
      identity_ids = try(identity.value["identity_ids"], null)
    }
  }

  dynamic "site_config" {
    for_each = var.site_config

    content {
      always_on              = site_config.value["always_on"]
      vnet_route_all_enabled = try(site_config.value["vnet_route_all_enabled"], false)
      app_command_line       = try(site_config.value["app_command_line"], null)

      dynamic "application_stack" {
        for_each = try(site_config.value["application_stack"], {})
        iterator = app_stack

        content {
          dotnet_version = try(app_stack.value["dotnet_version"], null)
          node_version   = try(app_stack.value["node_version"], null)
        }
      }

      dynamic "cors" {
        for_each = try(site_config.value["cors"], {})

        content {
          allowed_origins     = cors.value["allowed_origins"]
          support_credentials = try(cors.value["support_credentials"], false)
        }
      }

      dynamic "ip_restriction" {
        for_each = try(site_config.value["ip_restriction"], {})

        content {
          name       = ip_restriction.value["name"]
          action     = ip_restriction.value["action"]
          ip_address = ip_restriction.value["ip_address"]
          priority   = ip_restriction.value["priority"]
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      sticky_settings,
      app_settings["WEBSITE_RUN_FROM_PACKAGE"]
    ]
  }

  tags = var.tags
}

module "diagnostic" {
  for_each = var.diagnostic
  source   = "../diagnostic_setting"

  name                           = each.value["name"]
  target_resource_id             = azurerm_linux_web_app.this.id
  log_analytics_workspace_id     = each.value["log_analytics_workspace_id"]
  log_analytics_destination_type = try(each.value["log_analytics_destination_type"], null)
  log_categories                 = try(each.value["log_categories"], null)
  metric_categories              = try(each.value["metric_categories"], null)
}