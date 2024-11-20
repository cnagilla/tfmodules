resource "azurerm_route_table" "this" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  disable_bgp_route_propagation = var.disable_bgp_route_propagation
  tags                          = var.tags
}

module "routes" {
  for_each = var.routes
  source   = "../route"

  name                = each.key
  resource_group_name = var.resource_group_name
  route_table_name    = azurerm_route_table.this.name
  address_prefix      = each.value["address_prefix"]
  next_hop_type       = each.value["next_hop_type"]
  next_hop_in_ip      = try(each.value["next_hop_in_ip"], null)
}

resource "azurerm_subnet_route_table_association" "this" {
  count = length(var.subnet_ids)

  subnet_id      = var.subnet_ids[count.index]
  route_table_id = azurerm_route_table.this.id
}