resource "azurerm_public_ip" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.allocation_method
  domain_name_label   = var.domain_name_label
  sku                 = var.sku
  zones               = var.zones
  tags                = var.tags

  lifecycle {
    create_before_destroy = true
  }
}