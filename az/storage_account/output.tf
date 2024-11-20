output "name" {
  value       = azurerm_storage_account.this.name
  description = "Resource name"
}

output "id" {
  value       = azurerm_storage_account.this.id
  description = "Resource ID"
}

output "containers" {
  value = azurerm_storage_container.this
  #  value       = {for k, v in aws_lb_target_group.target-group: k => v.arn}
  description = "Storage account containers"
}

output "primary_access_key" {
  value       = azurerm_storage_account.this.primary_access_key
  description = "Storage primary access key"
}

output "primary_connection_string" {
  value       = azurerm_storage_account.this.primary_connection_string
  description = "Storage primary connection string"
}

output "primary_blob_connection_string" {
  value       = azurerm_storage_account.this.primary_blob_connection_string
  description = "Blob storage primary connection string"
}

output "primary_blob_endpoint" {
  value       = azurerm_storage_account.this.primary_blob_endpoint
  description = "Blob storage primary endpoint"
}

output "identity" {
  value       = var.identities != {} ? azurerm_storage_account.this.identity : null
  description = "Managed identity"
}