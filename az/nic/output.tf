output "id" {
  value       = azurerm_network_interface.this.id
  description = "Resource ID"
}

output "name" {
  value       = azurerm_network_interface.this.name
  description = "Resource name"
}

output "private_ip_address" {
  value       = azurerm_network_interface.this.private_ip_address
  description = "Primary IP address"
}

output "private_ip_addresses" {
  value       = azurerm_network_interface.this.private_ip_addresses
  description = "All IP addresses"
}

output "mac_address" {
  value       = azurerm_network_interface.this.mac_address
  description = "MAC address"
}
