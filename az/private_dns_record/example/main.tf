resource "random_string" "this" {
  length  = var.random_string_length
  special = false
  upper   = false
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${var.name}-${random_string.this.result}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_private_dns_zone" "this" {
  name                = "${var.name}-${random_string.this.result}.com"
  resource_group_name = azurerm_resource_group.this.name
}

module "dns_record" {
  source = "../../private_dns_record"

  resource_group_name = azurerm_resource_group.this.name
  zone_name           = azurerm_private_dns_zone.this.name
  a_records           = var.a_records
  cname_records       = var.cname_records
  tags                = var.tags
}