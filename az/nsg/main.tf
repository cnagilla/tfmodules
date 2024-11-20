resource "azurerm_network_security_group" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_rule" "this" {
  for_each = var.rules

  name                         = each.key
  resource_group_name          = var.resource_group_name
  network_security_group_name  = azurerm_network_security_group.this.name
  priority                     = each.value.priority
  direction                    = each.value.direction
  access                       = each.value.access
  protocol                     = each.value.protocol
  source_port_range            = try(each.value.src_port_range, null)
  source_port_ranges           = try(each.value.src_port_ranges, null)
  destination_port_range       = try(each.value.dest_port_range, null)
  destination_port_ranges      = try(each.value.dest_port_ranges, null)
  source_address_prefix        = try(each.value.src_prefix, null)
  source_address_prefixes      = try(each.value.src_prefixes, null)
  destination_address_prefix   = try(each.value.dest_prefix, null)
  destination_address_prefixes = try(each.value.dest_prefixes, null)
}

resource "azurerm_subnet_network_security_group_association" "this" {
  count = length(var.subnet_ids_association)

  subnet_id                 = var.subnet_ids_association[count.index]
  network_security_group_id = azurerm_network_security_group.this.id

  depends_on = [azurerm_network_security_rule.this]
}