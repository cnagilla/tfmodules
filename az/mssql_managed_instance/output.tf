output "name" {
  value       = azurerm_mssql_managed_instance.this.name
  description = "Resource name"
}

output "id" {
  value       = azurerm_mssql_managed_instance.this.id
  description = "Resource ID"
}

output "fqdn" {
  value       = azurerm_mssql_managed_instance.this.fqdn
  description = "Resource FQDN"
}

output "fqdn_public" {
  value       = local.public_fqdn
  description = "Resource public FQDN"
}

output "admin_user" {
  value       = azurerm_mssql_managed_instance.this.administrator_login
  description = "Admin user"
}

output "admin_password" {
  value       = azurerm_mssql_managed_instance.this.administrator_login_password
  description = "Admin password"
  sensitive   = true
}