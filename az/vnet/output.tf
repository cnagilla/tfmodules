output "name" {
  value       = azurerm_virtual_network.this.name
  description = "Resource name"
}

output "id" {
  value       = azurerm_virtual_network.this.id
  description = "Resource ID"
}

output "cidr" {
  value       = azurerm_virtual_network.this.address_space
  description = "CIDR"
}

output "subnets" {
  value       = module.subnets
  description = "Subnets"
}