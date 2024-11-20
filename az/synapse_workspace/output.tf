output "name" {
  value       = azurerm_synapse_workspace.this.name
  description = "Resource name"
}

output "id" {
  value       = azurerm_synapse_workspace.this.id
  description = "Resource ID"
}

output "connectivity_endpoints" {
  value       = azurerm_synapse_workspace.this.connectivity_endpoints
  description = "List of connectivity endpoints"
}

output "identity" {
  value       = azurerm_synapse_workspace.this.identity
  description = "System identity"
}

output "admin_user" {
  value       = azurerm_synapse_workspace.this.sql_administrator_login
  description = "Admin user name"
}

output "admin_password" {
  value       = azurerm_synapse_workspace.this.sql_administrator_login_password
  sensitive   = true
  description = "Admin user password"
}