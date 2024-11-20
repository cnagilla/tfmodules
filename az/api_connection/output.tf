output "name" {
  value       = azurerm_api_connection.this.name
  description = "Resource name"
}

output "id" {
  value       = azurerm_api_connection.this.id
  description = "Resource ID"
}

output "api_id" {
  value       = data.azurerm_managed_api.this.id
  description = "API ID"
}