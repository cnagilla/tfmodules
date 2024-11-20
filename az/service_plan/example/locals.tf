locals {
  diagnostic = {
    "default" : {
      "name" : "diag-${var.name}-${random_string.this.result}-asp",
      "log_analytics_workspace_id" : azurerm_log_analytics_workspace.this.id,
      "metric_categories" : {
        "AllMetrics" : {}
      }
    }
  }
}