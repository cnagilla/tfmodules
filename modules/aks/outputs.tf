output "aks_name" {
  description = "The name of the AKS cluster"
  value       = module.aks.aks_name
}

output "subnet_id" {
  description = "The ID of the Subnet"
  value       = module.network.subnet_id
}
