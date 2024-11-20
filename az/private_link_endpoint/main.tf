resource "azurerm_private_endpoint" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zones
    iterator = pdzg

    content {
      name                 = try(pdzg.value["name"], "pdzg-${pdzg.key}")
      private_dns_zone_ids = pdzg.value["private_dns_zone_ids"]
    }
  }

  private_service_connection {
    name                           = var.name
    is_manual_connection           = var.is_manual_connection
    private_connection_resource_id = var.private_connection_resource_id
    subresource_names              = var.subresource_names
  }

  tags = var.tags
}