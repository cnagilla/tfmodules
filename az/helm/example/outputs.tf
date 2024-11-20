#output "attributes" {
#  value       = module.argocd
#  description = "Resource attributes"
#}

output "argocd-password" {
  value       = random_password.argocd.result
  description = "Password"
  sensitive   = true
}

output "kubeconfig" {
  value       = azurerm_kubernetes_cluster.this.kube_config_raw
  description = "Kubectl config"
  sensitive   = true
}