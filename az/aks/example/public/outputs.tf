output "attributes" {
  value       = module.aks
  description = "Resource attributes"
  sensitive   = true
}

output "cloud-config" {
  value = data.template_file.userdata.rendered
}