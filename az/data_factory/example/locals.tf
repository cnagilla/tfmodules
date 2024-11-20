locals {
  diagnostic = {
    "default" : {
      "name" : "diag-${var.name}-${random_string.this.result}-adf",
      "log_analytics_workspace_id" : azurerm_log_analytics_workspace.this.id,
      "log_analytics_destination_type" : "AzureDiagnostics",
      "log_categories" : {
        "PipelineRuns" : {}
      },
      "metric_categories" : {
        "AllMetrics" : {}
      }
    }
  }
  global_parameter = {
    "url" : {
      "name" : "URL",
      "type" : "String",
      "value" : "https://some-test-url.mydomain.home/api/events"
    }
  }
}