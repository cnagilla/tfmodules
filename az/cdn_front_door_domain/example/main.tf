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

resource "azurerm_dns_zone" "example" {
  name                = "org-example.com"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_cdn_frontdoor_profile" "this" {
  name                = "fd-${var.name}-${random_string.this.result}"
  resource_group_name = azurerm_resource_group.this.name
  sku_name            = "Standard_AzureFrontDoor"
  tags                = var.tags
}

module "fd_domain" {
  source = "../../cdn_front_door_domain"

  name                     = "fddomain-${var.name}-${random_string.this.result}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id
  host_name                = join(".", ["test", azurerm_dns_zone.example.name])
  dns_zone_id              = azurerm_dns_zone.example.id
  certificate_type         = "ManagedCertificate"
  minimum_tls_version      = "TLS12"

}

