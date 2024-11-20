output "name" {
  value       = azurerm_application_insights.this.name
  description = "Resource name"
}

output "id" {
  value       = azurerm_application_insights.this.id
  description = "Resource ID"
}

output "app_id" {
  value       = azurerm_application_insights.this.app_id
  description = "App ID associated with this Application Insights"
}

output "instrumentation_key" {
  value       = azurerm_application_insights.this.instrumentation_key
  description = "Instrumentation Key"
}

output "connection_string" {
  value       = azurerm_application_insights.this.connection_string
  description = "Connection String"
}