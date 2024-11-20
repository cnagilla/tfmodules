output "name" {
  value       = azurerm_linux_function_app.this.name
  description = "Resource name"
}

output "id" {
  value       = azurerm_linux_function_app.this.id
  description = "Resource ID"
}

output "hostname" {
  value       = azurerm_linux_function_app.this.default_hostname
  description = "Default hostname"
}

output "identity" {
  value       = var.identities != {} ? azurerm_linux_function_app.this.identity : null
  description = "Managed identity"
}