resource "azurerm_linux_function_app" "this" {
  name                        = var.name
  resource_group_name         = var.resource_group_name
  location                    = var.location
  service_plan_id             = var.service_plan_id
  storage_account_name        = var.storage_account_name
  virtual_network_subnet_id   = var.virtual_network_subnet_id
  functions_extension_version = var.functions_extension_version
  storage_account_access_key  = var.storage_account_access_key
  app_settings                = var.app_settings
  builtin_logging_enabled     = var.builtin_logging_enabled
  client_certificate_mode     = var.client_certificate_mode
  https_only                  = var.https_only

  dynamic "identity" {
    for_each = var.identities

    content {
      type         = identity.value["type"]
      identity_ids = try(identity.value["identity_ids"], [])
    }
  }

  dynamic "sticky_settings" {
    for_each = var.sticky_settings

    content {
      app_setting_names = try(sticky_settings.value["app_setting_names"], null)
    }
  }

  dynamic "connection_string" {
    for_each = var.connection_string
    iterator = cstring

    content {
      name  = try(cstring.value["name"], cstring.key)
      type  = cstring.value["type"]
      value = cstring.value["value"]
    }
  }

  site_config {
    application_insights_connection_string = try(var.site_config["application_insights_connection_string"], null)
    application_insights_key               = try(var.site_config["application_insights_key"], null)
    ftps_state                             = try(var.site_config["ftps_state"], "Disabled")
    vnet_route_all_enabled                 = try(var.site_config["vnet_route_all_enabled"], false)

    dynamic "cors" {
      for_each = var.cors
      content {
        allowed_origins     = cors.value["allowed_origins"]
        support_credentials = try(cors.value["support_credentials"], false)
      }
    }

    dynamic "application_stack" {
      for_each = var.application_stack
      iterator = app_stack

      content {
        dotnet_version              = try(app_stack.value["dotnet_version"], null)
        use_custom_runtime          = try(app_stack.value["use_custom_runtime"], null)
        use_dotnet_isolated_runtime = try(app_stack.value["use_dotnet_isolated_runtime"], null)
      }
    }

    dynamic "ip_restriction" {
      for_each = var.ip_restrictions

      content {
        name        = try(ip_restriction.value["name"], ip_restriction.key)
        service_tag = try(ip_restriction.value["service_tag"], null)
        ip_address  = try(ip_restriction.value["ip_address"], null)
        priority    = try(ip_restriction.value["priority"], null)
        action      = try(ip_restriction.value["action"], null)
      }
    }
  }

  lifecycle {
    ignore_changes = [
      tags["hidden-link: /app-insights-instrumentation-key"],
      tags["hidden-link: /app-insights-resource-id"],
      tags["hidden-link: /app-insights-conn-string"],
      app_settings["WEBSITE_RUN_FROM_PACKAGE"],
      app_settings["WEBSITE_CONTENTOVERVNET"],
      app_settings["AzureWebJobsStorage"],
      app_settings["AzureWebJobs.UPCResolution.Disabled"],
      app_settings["AzureWebJobs.StoreRegistration.Disabled"],
      app_settings["AzureWebJobs.ImageGeneration.Disabled"],
      app_settings["AzureWebJobs.UPCLookupEnrichment.Disabled"],
      app_settings["AzureWebJobs.ProcessUPCRequestFunction.Disabled"],
      connection_string
    ]
  }
}

module "diagnostic" {
  for_each = var.diagnostic
  source   = "../diagnostic_setting"

  name                           = each.value["name"]
  target_resource_id             = azurerm_linux_function_app.this.id
  log_analytics_workspace_id     = each.value["log_analytics_workspace_id"]
  log_analytics_destination_type = try(each.value["log_analytics_destination_type"], null)
  log_categories                 = try(each.value["log_categories"], null)
  metric_categories              = try(each.value["metric_categories"], null)
}