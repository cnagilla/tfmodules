output "name" {
  value       = azurerm_container_registry.this.name
  description = "Resource name"
}

output "id" {
  value       = azurerm_container_registry.this.id
  description = "Resource ID"
}

output "url" {
  value       = azurerm_container_registry.this.login_server
  description = "URL for registry login"
}