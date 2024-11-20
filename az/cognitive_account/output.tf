output "name" {
  value       = azurerm_cognitive_account.this.name
  description = "Resource name"
}

output "id" {
  value       = azurerm_cognitive_account.this.id
  description = "Resource ID"
}

output "endpoint" {
  value       = azurerm_cognitive_account.this.endpoint
  description = "Service URL"
}

output "primary_access_key" {
  value       = azurerm_cognitive_account.this.primary_access_key
  sensitive   = true
  description = "Service access key"
}