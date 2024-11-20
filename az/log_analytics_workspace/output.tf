output "name" {
  value       = azurerm_log_analytics_workspace.this.name
  description = "Resource name"
}

output "id" {
  value       = azurerm_log_analytics_workspace.this.id
  description = "Resource ID"
}