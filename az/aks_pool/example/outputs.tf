output "attributes" {
  value       = module.aks_pool
  description = "Resource attributes"
}

output "ssh_private_key" {
  value       = tls_private_key.ssh.private_key_openssh
  description = "Private SSH key"
  sensitive   = true
}