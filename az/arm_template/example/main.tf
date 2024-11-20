resource "random_string" "this" {
  length  = var.random_string_length
  special = false
  upper   = false
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${var.name}-${random_string.this.result}"
  location = var.location
  tags     = var.tags
}

module "arm_template" {
  source = "../../arm_template"

  name                = "arm-${var.name}-${random_string.this.result}"
  resource_group_name = azurerm_resource_group.this.name
  deployment_mode     = "Incremental"
  parameters_content  = local.arm_template_params
  template_content    = local.arm_template
  tags                = var.tags
}