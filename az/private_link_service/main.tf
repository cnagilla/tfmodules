resource "azurerm_private_link_service" "this" {
  name                                        = var.name
  location                                    = var.location
  resource_group_name                         = var.resource_group_name
  load_balancer_frontend_ip_configuration_ids = var.load_balancer_frontend_ip_configuration_ids
  tags                                        = var.tags

  dynamic "nat_ip_configuration" {
    for_each = var.nat_ip_configurations

    content {
      name               = try(nat_ip_configuration.value["name"], "${var.nat_ip_configuration_name_prefix}-${nat_ip_configuration.key}")
      primary            = nat_ip_configuration.value["primary"]
      subnet_id          = nat_ip_configuration.value["subnet_id"]
      private_ip_address = try(nat_ip_configuration.value["ip"], null)
    }
  }
}