output "name" {
  value       = azurerm_servicebus_namespace.this.name
  description = "Namespace name"
}

output "id" {
  value       = azurerm_servicebus_namespace.this.id
  description = "Namespace ID"
}

output "topics" {
  value       = azurerm_servicebus_topic.this
  description = "Topics"
}

output "queues" {
  value       = azurerm_servicebus_queue.this
  description = "Queues"
}

output "subscriptions" {
  value       = azurerm_servicebus_subscription.this
  description = "Subscriptions"
}