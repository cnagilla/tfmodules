output "attributes" {
  value       = module.vm
  description = "Resource attributes"
}

output "windows-password" {
  value       = random_password.windows.result
  description = "Windows VM password"
  sensitive   = true
}