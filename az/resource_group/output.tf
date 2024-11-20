output "name" {
  value       = azurerm_resource_group.this.name
  description = "Resource name"
}

output "id" {
  value       = azurerm_resource_group.this.id
  description = "Resource ID"
}

output "location" {
  value       = azurerm_resource_group.this.location
  description = "Resource location"
}