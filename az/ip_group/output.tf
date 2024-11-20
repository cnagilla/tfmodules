output "id" {
  value       = azurerm_ip_group.this.id
  description = "Resource ID"
}

output "name" {
  value       = azurerm_ip_group.this.name
  description = "Resource name"
}

output "cidrs" {
  value       = azurerm_ip_group.this.cidrs
  description = "CIDRs"
}