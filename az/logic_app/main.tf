resource "azurerm_logic_app_workflow" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  enabled             = var.enabled
  parameters          = var.parameters
  workflow_parameters = var.workflow_parameters
  tags                = var.tags

  dynamic "identity" {
    for_each = var.identity

    content {
      type         = identity.value["type"]
      identity_ids = try(identity.value["identity_ids"], null)
    }
  }

  lifecycle {
    ignore_changes = [
      parameters,
      workflow_parameters
    ]
  }
}