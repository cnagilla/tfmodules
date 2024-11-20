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

resource "azurerm_storage_account" "this" {
  name                     = "sta${var.name}${random_string.this.result}"
  location                 = azurerm_resource_group.this.location
  resource_group_name      = azurerm_resource_group.this.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

resource "azurerm_storage_share" "logic_app_storage_account_share" {
  name                 = "${local.logic_app.name}-content"
  storage_account_name = azurerm_storage_account.this.name
  quota                = "5000"
}

resource "azurerm_service_plan" "this" {
  name                = "sp-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  os_type             = "Windows"
  sku_name            = "WS1"
  tags                = var.tags
}

resource "azurerm_virtual_network" "this" {
  name                = "vnet-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.0.0.0/16"]
  tags                = var.tags
}

resource "azurerm_subnet" "this" {
  name                 = "snet-${var.name}-${random_string.this.result}"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.0.0/24"]

  delegation {
    name = "function_app"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = "log-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

resource "azurerm_application_insights" "this" {
  name                = "appins-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  application_type    = "web"
}

module "logic_app_standard" {
  source = "../../logic_app_standard"

  name                       = local.logic_app.name
  location                   = azurerm_resource_group.this.location
  resource_group_name        = azurerm_resource_group.this.name
  app_service_plan_id        = azurerm_service_plan.this.id
  storage_account_name       = azurerm_storage_account.this.name
  storage_account_access_key = azurerm_storage_account.this.primary_access_key
  site_config                = local.logic_app.site_config
  virtual_network_subnet_id  = azurerm_subnet.this.id
  identities                 = local.logic_app.identities
  app_settings               = local.logic_app.app_settings
  runtime_version            = "~4"
  https_only                 = true
  diagnostic                 = local.logic_app.diagnostic
  tags                       = var.tags
}