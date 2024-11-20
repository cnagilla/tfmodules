output "name" {
  value       = azurerm_logic_app_standard.this.name
  description = "Resource name"
}

output "id" {
  value       = azurerm_logic_app_standard.this.id
  description = "Resource ID"
}

output "hostname" {
  value       = azurerm_logic_app_standard.this.default_hostname
  description = "Default hostname"
}

output "identity" {
  value       = var.identities != {} ? azurerm_logic_app_standard.this.identity : null
  description = "Managed identity"
}