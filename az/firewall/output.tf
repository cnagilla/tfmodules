output "name" {
  value       = azurerm_firewall.this.name
  description = "Resource name"
}

output "id" {
  value       = azurerm_firewall.this.id
  description = "Resource ID"
}

output "policy_id" {
  value       = var.firewall_policy_name != "" ? azurerm_firewall_policy.this[0].id : null
  description = "Policy ID"
}

output "policy_name" {
  value       = var.firewall_policy_name != "" ? azurerm_firewall_policy.this[0].name : null
  description = "Policy name"
}

output "attr" {
  value       = azurerm_firewall.this
  description = "All firewall attributes"
}