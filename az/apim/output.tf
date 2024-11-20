output "name" {
  value       = azurerm_api_management.this.name
  description = "Resource name"
}

output "id" {
  value       = azurerm_api_management.this.id
  description = "Resource ID"
}

output "private_ips" {
  value       = azurerm_api_management.this.private_ip_addresses
  description = "Private IP"
}

output "fqdn" {
  value       = substr(azurerm_api_management.this.gateway_url, 8, -1)
  description = "FQDN"
}

output "additional_location" {
  value       = azurerm_api_management.this.additional_location
  description = "Additional locations"
}

output "identity" {
  value       = azurerm_api_management.this.identity
  description = "Identity"
}
