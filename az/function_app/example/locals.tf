locals {
  function = {
    "name" : "func-${var.name}-${random_string.this.result}"
    "app_settings" : {
      "AzureWebJobsStorage" : azurerm_storage_account.this.primary_connection_string,
      "WEBSITE_CONTENTAZUREFILECONNECTIONSTRING" : azurerm_storage_account.this.primary_connection_string,
      "CONTAINER_NAME" : "azure-webjobs-secrets"
    },
    "connection_string" : {
      "cust" : {
        "name" : "CustomConnectionString"
        "type" : "Custom"
        "value" : "SomeSecretString"
      }
    }
    "site_config" : {
      "application_insights_connection_string" : azurerm_application_insights.this.connection_string,
      "vnet_route_all_enabled" : true
    },
    "identities" : {
      "default" : {
        "type" : "SystemAssigned",
        "identity_ids" : null
      }
    },
    "application_stack" : {
      "default" : {
        "dotnet_version" : "6.0"
      }
    },
    "ip_restrictions" : {
      "allow_eventgrid_trigger" : {
        "priority" : "1001"
        "service_tag" : "AzureEventGrid"
        "action" : "Allow"
      },
      "allow_azurecloud" : {
        "priority" : "1002"
        "service_tag" : "AzureCloud"
        "action" : "Allow"
      },
      "deny_all" : {
        "priority" : "1100"
        "ip_address" : "0.0.0.0/0"
        "action" : "Deny"
      }
    },
    "diagnostic" : {
      "default" : {
        "name" : "diag-${var.name}-${random_string.this.result}-func",
        "log_analytics_workspace_id" : azurerm_log_analytics_workspace.this.id,
        "log_categories" : {
          "FunctionAppLogs" : {}
        }
        "metric_categories" : {
          "AllMetrics" : {}
        }
      }
    }
  }
}