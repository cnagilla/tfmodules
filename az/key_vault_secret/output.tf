output "name" {
  value       = azurerm_key_vault_secret.this.name
  description = "Resource name"
}

output "id" {
  value       = azurerm_key_vault_secret.this.id
  description = "Resource ID"
}

output "version" {
  value       = azurerm_key_vault_secret.this.version
  description = "Key vault secret version"
}

output "versionless_id" {
  value       = azurerm_key_vault_secret.this.versionless_id
  description = "Key vault secret versionless ID"
}