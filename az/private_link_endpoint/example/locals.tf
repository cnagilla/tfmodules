locals {
  private_endpoints = {
    "service" : {
      "name" : "pep-${var.name}-${random_string.this.result}-service",
      "target_resource_id" : azurerm_private_link_service.this.id,
      "private_dns_zones" : {
        "default" : {
          "name" : "dz-${var.name}-${random_string.this.result}-service",
          "private_dns_zone_ids" : [azurerm_private_dns_zone.service.id]
        }
      }
    }
    "app_config" : {
      "name" : "pep-${var.name}-${random_string.this.result}-appcfg",
      "target_resource_id" : azurerm_app_configuration.this.id,
      "target_subresource_names" : ["configurationStores"],
      "private_dns_zones" : {
        "default" : {
          "name" : "dz-${var.name}-${random_string.this.result}-appcfg",
          "private_dns_zone_ids" : [azurerm_private_dns_zone.appcfg.id]
        }
      }
    }
  }
}