locals {
  insights = {
    "default" : {
      "log_analytics_workspace_id" : azurerm_log_analytics_workspace.this.id,
      "retention_in_days" : 14
    }
  }
}