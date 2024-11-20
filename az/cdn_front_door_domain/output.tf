output "name" {
  value       = azurerm_cdn_frontdoor_custom_domain.this.name
  description = "Resource name"
}

output "id" {
  value       = azurerm_cdn_frontdoor_custom_domain.this.id
  description = "Resource ID"
}

output "expiration_date" {
  value       = azurerm_cdn_frontdoor_custom_domain.this.expiration_date
  description = "Expiration"
}

output "validation_token" {
  value       = azurerm_cdn_frontdoor_custom_domain.this.validation_token
  description = "Challenge"
}