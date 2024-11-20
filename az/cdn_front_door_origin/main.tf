resource "azurerm_cdn_frontdoor_origin" "this" {
  name                           = var.name
  enabled                        = var.enabled
  cdn_frontdoor_origin_group_id  = var.cdn_frontdoor_origin_group_id
  host_name                      = var.host_name
  certificate_name_check_enabled = var.certificate_name_check_enabled
  http_port                      = var.http_port
  https_port                     = var.https_port
  origin_host_header             = var.origin_host_header
  priority                       = var.priority
  weight                         = var.weight
}