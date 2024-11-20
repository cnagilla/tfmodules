output "kubeconfig" {
  value       = module.aks.kube_config_raw
  description = "Kubernetes config RAW"
  sensitive   = true
}

output "cloud-config" {
  value = data.template_file.userdata.rendered
}