output "id" {
  value       = azurerm_search_service.this.id
  description = "Resource ID"
}

output "name" {
  value       = azurerm_search_service.this.name
  description = "Resource name"
}

output "primary_key" {
  value       = azurerm_search_service.this.primary_key
  description = "Primary access key"
}