output "name" {
  value       = azurerm_bastion_host.this.name
  description = "Resource name"
}

output "id" {
  value       = azurerm_bastion_host.this.id
  description = "Resource ID"
}

output "fqdn" {
  value       = azurerm_bastion_host.this.dns_name
  description = "FQDN"
}

output "public_ip" {
  value       = module.public_ip.ip
  description = "Public IP address"
}
