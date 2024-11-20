output "name" {
  value       = azurerm_storage_container.this.name
  description = "Resource name"
}

output "id" {
  value       = azurerm_storage_container.this.id
  description = "Resource ID"
}