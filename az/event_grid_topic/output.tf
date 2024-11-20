output "name" {
  value       = azurerm_eventgrid_topic.this.name
  description = "Resource name"
}

output "id" {
  value       = azurerm_eventgrid_topic.this.id
  description = "Resource ID"
}

output "access_key" {
  value       = azurerm_eventgrid_topic.this.primary_access_key
  description = "Resource name"
}

output "endpoint" {
  value       = azurerm_eventgrid_topic.this.endpoint
  description = "Endpoint"
}