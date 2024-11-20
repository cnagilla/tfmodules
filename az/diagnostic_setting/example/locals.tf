locals {
  diagnostic = {
    "fd" : {
      "name" : "diag-${var.name}-${random_string.this.result}-fd",
      "target_resource_id" : azurerm_cdn_frontdoor_profile.this.id,
      "log_categories" : {
        "FrontDoorAccessLog" : {
          "retention" : {
            "enabled" : true,
            "days" : 10
          }
        },
        "FrontDoorWebApplicationFirewallLog" : {}
      }
    },
    "asp" : {
      "name" : "diag-${var.name}-${random_string.this.result}-asp",
      "target_resource_id" : azurerm_service_plan.this.id,
      "metric_categories" : {
        "AllMetrics" : {}
      }
    },
    "app_config" : {
      "name" : "diag-${var.name}-${random_string.this.result}-appcfg",
      "target_resource_id" : azurerm_app_configuration.this.id,
      "log_categories" : {
        "Audit" : {}
      },
      "metric_categories" : {
        "AllMetrics" : {}
      }
    }
  }
}