output "name" {
  value       = azurerm_service_plan.this.name
  description = "Resource name"
}

output "id" {
  value       = azurerm_service_plan.this.id
  description = "Resource ID"
}