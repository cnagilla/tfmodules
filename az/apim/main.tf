resource "random_string" "this" {
  length  = var.random_string_length
  special = false
  upper   = false
}

resource "azurerm_api_management" "this" {
  name                 = "${var.name_prefix}-${random_string.this.result}"
  location             = var.location
  resource_group_name  = var.resource_group_name
  publisher_name       = var.publisher_name
  publisher_email      = var.publisher_email
  sku_name             = var.sku_name
  virtual_network_type = var.virtual_network_type
  public_ip_address_id = var.public_ip_address_id
  zones                = var.zones

  dynamic "virtual_network_configuration" {
    for_each = var.virtual_network_type == "None" ? {} : { subnet_id = var.subnet_id }

    content {
      subnet_id = virtual_network_configuration.value
    }
  }

  dynamic "additional_location" {
    for_each = var.additional_location

    content {
      location = additional_location.value["location"]

      dynamic "virtual_network_configuration" {
        for_each = try(additional_location.value["virtual_network_configuration"], {})

        content {
          subnet_id = virtual_network_configuration.value["subnet_id"]
        }
      }
    }
  }

  dynamic "identity" {
    for_each = var.identity

    content {
      type         = identity.value["type"]
      identity_ids = try(identity.value["identity_ids"], null)
    }
  }

  tags = var.tags
}

module "logger" {
  for_each = var.logger
  source   = "../apim_logger"

  name                             = try(each.value["name"], "${var.name_prefix}-${random_string.this.result}-${each.key}")
  resource_group_name              = var.resource_group_name
  api_management_name              = azurerm_api_management.this.name
  app_insights_id                  = each.value["app_insights_id"]
  app_insights_instrumentation_key = each.value["app_insights_instrumentation_key"]
}

module "diagnostic" {
  for_each = var.diagnostic
  source   = "../diagnostic_setting"

  name                           = each.value["name"]
  target_resource_id             = azurerm_api_management.this.id
  log_analytics_workspace_id     = each.value["log_analytics_workspace_id"]
  log_analytics_destination_type = each.value["log_analytics_destination_type"]
  log_categories                 = each.value["log_categories"]
}