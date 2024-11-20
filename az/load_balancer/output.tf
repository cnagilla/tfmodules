output "name" {
  value       = azurerm_lb.this.name
  description = "Resource name"
}

output "id" {
  value       = azurerm_lb.this.id
  description = "Resource ID"
}

output "public_ip_name" {
  value       = module.public_ip.name
  description = "Load balancer public IP name"
}

output "public_ip" {
  value       = module.public_ip.ip
  description = "Load balancer public IP"
}

output "frontend_ip_config_id" {
  value       = azurerm_lb.this.frontend_ip_configuration[0].id
  description = "Load balancer frontend configuration ID"
}