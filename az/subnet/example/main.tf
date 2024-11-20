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

resource "azurerm_virtual_network" "this" {
  name                = "vnet-${var.name}-${random_string.this.result}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags
}

module "subnet" {
  for_each = local.subnets
  source   = "../../subnet"

  name                          = try(each.value["name"], "snet-${var.name}-${random_string.this.result}-${each.key}")
  resource_group_name           = azurerm_resource_group.this.name
  subnet_address_space          = each.value["cidr"]
  virtual_network_name          = azurerm_virtual_network.this.name
  delegations                   = try(each.value["delegations"], {})
  enforce_private_link_endpoint = try(each.value["enforce_private_link_endpoint"], false)
  enforce_private_link_service  = try(each.value["enforce_private_link_service"], false)
  service_endpoints             = try(each.value["service_endpoints"], [])
}