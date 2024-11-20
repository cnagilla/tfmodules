resource "azurerm_monitor_diagnostic_setting" "this" {
  name                           = var.name
  target_resource_id             = var.target_resource_id
  log_analytics_destination_type = var.log_analytics_destination_type
  log_analytics_workspace_id     = var.log_analytics_workspace_id

  dynamic "log" {
    for_each = var.log_categories != {} || var.metric_categories != {} ? toset(data.azurerm_monitor_diagnostic_categories.this.log_category_types) : []

    content {
      category = log.value
      enabled  = contains(keys(var.log_categories), log.value) ? true : false

      retention_policy {
        enabled = try(var.log_categories[log.value]["retention"]["enabled"], false)
        days    = try(var.log_categories[log.value]["retention"]["days"], 0)
      }
    }
  }

  dynamic "metric" {
    for_each = var.metric_categories != {} || var.log_categories != {} ? toset(data.azurerm_monitor_diagnostic_categories.this.metrics) : []

    content {
      category = metric.value
      enabled  = contains(keys(var.metric_categories), metric.value) ? true : false

      retention_policy {
        enabled = try(var.metric_categories[metric.value]["retention"]["enabled"], false)
        days    = try(var.metric_categories[metric.value]["retention"]["days"], 0)
      }
    }
  }

  depends_on = [data.azurerm_monitor_diagnostic_categories.this]
}