output "name" {
  value       = azurerm_app_configuration.this.name
  description = "Resource name"
}

output "id" {
  value       = azurerm_app_configuration.this.id
  description = "Resource ID"
}

output "endpoint" {
  value       = azurerm_app_configuration.this.endpoint
  description = "URL"
}