locals {
  diagnostic = {
    "default" : {
      "name" : "diag-${var.name}-${random_string.this.result}-fd",
      "log_analytics_workspace_id" : azurerm_log_analytics_workspace.this.id,
      "log_categories" : {
        "FrontDoorAccessLog" : {},
        "FrontDoorWebApplicationFirewallLog" : {}
      }
    }
  }
}