output "name" {
  value       = azurerm_public_ip.this.name
  description = "Resource name"
}

output "id" {
  value       = azurerm_public_ip.this.id
  description = "Resource ID"
}

output "ip" {
  value       = azurerm_public_ip.this.ip_address
  description = "IP address"
}

output "fqdn" {
  value       = azurerm_public_ip.this.fqdn
  description = "FQDN"
}