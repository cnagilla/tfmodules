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

resource "azurerm_service_plan" "this" {
  name                = "asp-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  os_type             = "Linux"
  sku_name            = "P1v2"
  tags                = var.tags
}

module "app_service_linux" {
  for_each = var.app_services
  source   = "../../app_service_linux"

  name                      = "app-${var.name}-${each.key}-${random_string.this.result}"
  location                  = azurerm_resource_group.this.location
  resource_group_name       = azurerm_resource_group.this.name
  service_plan_id           = azurerm_service_plan.this.id
  identities                = try(each.value["identities"], {})
  app_settings              = try(each.value["app_settings"], {})
  virtual_network_subnet_id = try(each.value["virtual_network_subnet_id"], null)
  site_config               = try(each.value["site_config"], {})
  tags                      = var.tags
}