output "name" {
  value       = azurerm_resource_group_template_deployment.this.name
  description = "Resource name"
}

output "id" {
  value       = azurerm_resource_group_template_deployment.this.id
  description = "Resource ID"
}

output "template_output" {
  value = jsondecode(azurerm_resource_group_template_deployment.this.output_content)
}