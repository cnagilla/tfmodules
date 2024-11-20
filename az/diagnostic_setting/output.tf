output "name" {
  value       = azurerm_monitor_diagnostic_setting.this.name
  description = "Resource name"
}

output "id" {
  value       = azurerm_monitor_diagnostic_setting.this.id
  description = "Resource ID"
}

output "log_categories" {
  value       = sort(data.azurerm_monitor_diagnostic_categories.this.log_category_types)
  description = "Log categories"
}

output "log_metrics" {
  value       = sort(data.azurerm_monitor_diagnostic_categories.this.metrics)
  description = "Log metrics"
}