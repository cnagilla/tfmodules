output "name" {
  value       = azurerm_linux_web_app.this.name
  description = "Resource name"
}

output "id" {
  value       = azurerm_linux_web_app.this.id
  description = "Resource ID"
}

output "identity" {
  value       = var.identities != {} ? azurerm_linux_web_app.this.identity : null
  description = "Managed identity"
}

output "fqdn" {
  value       = azurerm_linux_web_app.this.default_hostname
  description = "Default hostname"
}