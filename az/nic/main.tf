resource "azurerm_network_interface" "this" {
  name                 = var.name
  location             = var.location
  resource_group_name  = var.resource_group_name
  enable_ip_forwarding = var.enable_ip_forwarding

  dynamic "ip_configuration" {
    for_each = var.ip_configuration
    iterator = conf

    content {
      name                          = try(conf.value["name"], "${var.name}-${conf.key}")
      private_ip_address_allocation = conf.value["private_ip_address_allocation"]
      subnet_id                     = try(conf.value["subnet_id"], null)
      private_ip_address            = try(conf.value["private_ip_address"], null)
      public_ip_address_id          = try(conf.value["public_ip_address_id"], null)
      primary                       = try(conf.value["primary"], false)
    }
  }

  tags = var.tags
}