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

module "front_door" {
  source = "../../front_door"

  name                = "fd-${var.name}-${random_string.this.result}"
  resource_group_name = azurerm_resource_group.this.name
  config              = local.front_door_config
  tags                = var.tags
}