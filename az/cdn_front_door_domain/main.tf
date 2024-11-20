resource "azurerm_cdn_frontdoor_custom_domain" "this" {
  name                     = var.name
  cdn_frontdoor_profile_id = var.cdn_frontdoor_profile_id
  dns_zone_id              = var.dns_zone_id
  host_name                = var.host_name

  tls {
    certificate_type        = var.certificate_type
    minimum_tls_version     = var.minimum_tls_version
    cdn_frontdoor_secret_id = var.cdn_frontdoor_secret_id
  }
}