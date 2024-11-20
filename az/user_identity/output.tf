output "name" {
  value       = azurerm_user_assigned_identity.this.name
  description = "Resource name"
}

output "id" {
  value       = azurerm_user_assigned_identity.this.id
  description = "Resource ID"
}

output "principal_id" {
  value       = azurerm_user_assigned_identity.this.principal_id
  description = "Principal ID"
}