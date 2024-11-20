output "name" {
  value       = azurerm_data_factory.this.name
  description = "Resource name"
}

output "id" {
  value       = azurerm_data_factory.this.id
  description = "Resource ID"
}

output "identity" {
  value       = var.identities != {} ? azurerm_data_factory.this.identity : null
  description = "Managed identity"
}