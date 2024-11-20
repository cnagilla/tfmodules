locals {
  diagnostic = {
    "default" : {
      "name" : "diag-${var.name}-${random_string.this.result}-egtopic",
      "log_analytics_workspace_id" : azurerm_log_analytics_workspace.this.id,
      "log_categories" : {
        "DeliveryFailures" : {},
        "PublishFailures" : {}
      }
    }
  }
}