resource "azurerm_private_dns_a_record" "this" {
  for_each = var.a_records

  name                = each.value["name"]
  zone_name           = var.zone_name
  resource_group_name = var.resource_group_name
  ttl                 = each.value["ttl"]
  records             = each.value["records"]
  tags                = var.tags
}

resource "azurerm_private_dns_cname_record" "this" {
  for_each = var.cname_records

  name                = each.value["name"]
  zone_name           = var.zone_name
  resource_group_name = var.resource_group_name
  ttl                 = each.value["ttl"]
  record              = each.value["record"]
  tags                = var.tags
}