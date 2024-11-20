resource "azurerm_private_dns_zone" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

module "linked_networks" {
  for_each = var.linked_networks
  source   = "../private_dns_zone_vnet_link"

  name                  = try(each.value["name"], "${var.linked_vnets_name_prefix}-${each.key}")
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = each.value["id"]
  registration_enabled  = try(each.value["registration_enabled"], false)
  tags                  = var.tags
}

module "dns_records" {
  source = "../private_dns_record"

  resource_group_name = var.resource_group_name
  zone_name           = azurerm_private_dns_zone.this.name
  a_records           = var.a_records
  cname_records       = var.cname_records
  tags                = var.tags
}