output "name" {
  value       = azurerm_kubernetes_cluster.this.name
  description = "Name"
}

output "id" {
  value       = azurerm_kubernetes_cluster.this.id
  description = "ID"
}

output "kube_config_raw" {
  value       = azurerm_kubernetes_cluster.this.kube_config_raw
  description = "Kubectl ready config"
  sensitive   = true
}

output "kube_config" {
  value       = azurerm_kubernetes_cluster.this.kube_config
  description = "Kubernetes access config"
  sensitive   = true
}

output "principal_id" {
  value       = azurerm_kubernetes_cluster.this.identity.0.principal_id
  description = "Cluster identity principal ID"
}

output "kubelet_object_id" {
  value       = azurerm_kubernetes_cluster.this.kubelet_identity.0.object_id
  description = "Kubelet identity object ID"
}

output "kubernetes_oidc_issuer_url" {
  value = azurerm_kubernetes_cluster.this.oidc_issuer_url
  description = "Kubernetes oidc issuer url"           
}

output "kubelet_tenant_id" {                                           
  value       = azurerm_kubernetes_cluster.this.identity.0.tenant_id
  description = "Kubelet identity tenant ID"                           
} 

output "kubelet_client_id" {
  value       = azurerm_kubernetes_cluster.this.kubelet_identity.0.client_id
  description = "Kubelet identity client ID"
}
