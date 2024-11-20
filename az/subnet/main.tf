resource "azurerm_subnet" "this" {
  name                                          = var.name
  resource_group_name                           = var.resource_group_name
  virtual_network_name                          = var.virtual_network_name
  address_prefixes                              = [var.subnet_address_space]
  private_endpoint_network_policies_enabled     = var.enforce_private_link_endpoint
  private_link_service_network_policies_enabled = var.enforce_private_link_service
  service_endpoints                             = var.service_endpoints

  dynamic "delegation" {
    for_each = var.delegations

    content {
      name = delegation.key
      service_delegation {
        name    = delegation.value["name"]
        actions = delegation.value["actions"]
      }
    }
  }
}