output "name" {
  value       = azurerm_role_assignment.this.name
  description = "Resource name"
}

output "id" {
  value       = azurerm_role_assignment.this.id
  description = "Resource ID"
}

output "principal_type" {
  value       = azurerm_role_assignment.this.principal_type
  description = "Principal type"
}