resource "azurerm_resource_group_template_deployment" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  deployment_mode     = var.deployment_mode
  parameters_content  = var.parameters_content
  template_content    = var.template_content
  tags                = var.tags
}