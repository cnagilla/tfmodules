locals {
  second_location = "eastus"
  identity = {
    "default" : {
      "type" : "SystemAssigned"
    }
  }
  diagnostic = {
    "default" : {
      "name" : "diag-${var.name}-${random_string.this.result}-apim"
      "log_analytics_workspace_id" : azurerm_log_analytics_workspace.this.id
      "log_analytics_destination_type" : "Dedicated"
      "log_categories" : {
        "GatewayLogs" : {}
      }
    }
  }
  logger = {
    "default" : {
      "name" : azurerm_application_insights.this.name
      "app_insights_id" : azurerm_application_insights.this.id
      "app_insights_instrumentation_key" : azurerm_application_insights.this.instrumentation_key
    }
  }
  additional_location = {
    "eastus" : {
      "location" : local.second_location
      "virtual_network_configuration" : {
        "eastus" : {
          "subnet_id" : azurerm_subnet.apim_eus.id
        }
      }
    }
  }
}