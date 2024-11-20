output "id" {
  value       = azurerm_subnet.this.id
  description = "Resource ID"
}

output "name" {
  value       = azurerm_subnet.this.name
  description = "Resource name"
}

output "cidr" {
  value       = azurerm_subnet.this.address_prefixes[0]
  description = "CIDR"
}