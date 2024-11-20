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

module "network" {
  for_each = var.virtual_networks
  source   = "../../vnet"

  name                = "vnet-${var.name}-${random_string.this.result}-${each.key}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  vnet_address_space  = each.value["cidr"]
  subnets             = each.value["subnets"]
  subnets_name_prefix = "snet"
  tags                = var.tags
}