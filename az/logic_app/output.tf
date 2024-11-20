output "name" {
  value       = azurerm_logic_app_workflow.this.name
  description = "Resource name"
}

output "id" {
  value       = azurerm_logic_app_workflow.this.id
  description = "Resource ID"
}

output "endpoint" {
  value       = azurerm_logic_app_workflow.this.access_endpoint
  description = "URL"
}

output "identity" {
  value       = azurerm_logic_app_workflow.this.identity
  description = "Identity"
}