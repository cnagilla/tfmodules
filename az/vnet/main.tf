resource "azurerm_virtual_network" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
  tags                = var.tags
}

module "subnets" {
  for_each = var.subnets
  source   = "../subnet"

  name                          = try(each.value["name"], "${var.subnets_name_prefix}-${each.key}")
  resource_group_name           = var.resource_group_name
  subnet_address_space          = each.value["cidr"]
  virtual_network_name          = azurerm_virtual_network.this.name
  delegations                   = try(each.value["delegations"], {})
  enforce_private_link_endpoint = try(each.value["enforce_private_link_endpoint"], false)
  enforce_private_link_service  = try(each.value["enforce_private_link_service"], false)
  service_endpoints             = try(each.value["service_endpoints"], [])
}