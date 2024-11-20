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

resource "azurerm_cdn_frontdoor_profile" "this" {
  name                = "fd-${var.name}-${random_string.this.result}"
  resource_group_name = azurerm_resource_group.this.name
  sku_name            = "Standard_AzureFrontDoor"
  tags                = var.tags
}

resource "azurerm_cdn_frontdoor_origin_group" "this" {
  name                     = "fdog-${var.name}-${random_string.this.result}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id

  load_balancing {}
}

module "front_door_origin" {
  source = "../../cdn_front_door_origin"

  name                          = "fdorig-${var.name}-${random_string.this.result}"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.this.id
  host_name                     = "centos.com"
  origin_host_header            = "www.contoso.com"
  http_port                     = 80
  https_port                    = 443
  priority                      = 1
  weight                        = 1
  enabled                       = true
}