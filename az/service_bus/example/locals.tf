locals {
  topics = {
    "topic1" : {}
    "topic2" : {
      "name" : "sbt-${var.name}-${random_string.this.result}"
    }
  }
  queues = {
    "queue1" : {}
    "queue2" : {
      "name" : "sbq-${var.name}-${random_string.this.result}"
    }
  }
  diagnostic = {
    "default" : {
      "name" : "diag-${var.name}-${random_string.this.result}-sb",
      "log_analytics_workspace_id" : azurerm_log_analytics_workspace.this.id,
      "log_categories" : {
        "OperationalLogs" : {},
        "RuntimeAuditLogs" : {}
      }
    }
  }
}