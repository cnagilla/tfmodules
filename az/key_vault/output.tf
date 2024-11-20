output "name" {
  value       = azurerm_key_vault.this.name
  description = "Resource name"
}

output "id" {
  value       = azurerm_key_vault.this.id
  description = "Resource ID"
}

output "uri" {
  value       = azurerm_key_vault.this.vault_uri
  description = "URI"
}