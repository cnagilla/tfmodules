locals {
  logic_app = {
    "name" : "logic-${var.name}-${random_string.this.result}"
    "app_settings" : {
      "APPLICATIONINSIGHTS_CONNECTION_STRING" : azurerm_application_insights.this.connection_string
      "FUNCTIONS_WORKER_RUNTIME"     = "node"
      "WEBSITE_NODE_DEFAULT_VERSION" = "~18"
      "WEBSITE_CONTENTOVERVNET"      = 1
    }
    "site_config" : {
      "default" : {
        "always_on" : false
        "vnet_route_all_enabled" : true
      }
    }
    "identities" : {
      "default" : {
        "type" : "SystemAssigned"
        "identity_ids" : null
      }
    }
    "diagnostic" : {
      "default" : {
        "name" : "diag-${var.name}-${random_string.this.result}-logic"
        "log_analytics_workspace_id" : azurerm_log_analytics_workspace.this.id
        "log_categories" : {
          "WorkflowRuntime" : {}
          "FunctionAppLogs" : {}
        }
        "metric_categories" : {
          "AllMetrics" : {}
        }
      }
    }
  }
}