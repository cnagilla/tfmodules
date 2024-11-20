resource "azurerm_ip_group_cidr" "this" {
  ip_group_id = var.ip_group_id
  cidr        = var.cidr
}