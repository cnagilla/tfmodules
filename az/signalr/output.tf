output "name" {
  value       = azurerm_signalr_service.this.name
  description = "Resource name"
}

output "id" {
  value       = azurerm_signalr_service.this.id
  description = "Resource ID"
}

output "fqdn" {
  value       = azurerm_signalr_service.this.hostname
  description = "FQDN"
}

output "primary_access_key" {
  value       = azurerm_signalr_service.this.primary_access_key
  description = "Primary access key"
}