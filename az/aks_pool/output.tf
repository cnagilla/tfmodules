output "name" {
  value       = azurerm_kubernetes_cluster_node_pool.this.name
  description = "Name"
}

output "id" {
  value       = azurerm_kubernetes_cluster_node_pool.this.id
  description = "ID"
}