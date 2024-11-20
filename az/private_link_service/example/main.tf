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

resource "azurerm_virtual_network" "this" {
  name                = "vnet-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "this" {
  name                 = "snet-${var.name}-${random_string.this.result}"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.1.0/24"]

  enforce_private_link_service_network_policies = true
}

resource "azurerm_public_ip" "this" {
  name                = "pip-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "this" {
  name                = "lb-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = azurerm_public_ip.this.name
    public_ip_address_id = azurerm_public_ip.this.id
  }
}

module "private_service" {
  source = "../../private_link_service"

  name                                        = "psvc-${var.name}-${random_string.this.result}"
  location                                    = azurerm_resource_group.this.location
  resource_group_name                         = azurerm_resource_group.this.name
  load_balancer_frontend_ip_configuration_ids = [azurerm_lb.this.frontend_ip_configuration.0.id]
  nat_ip_configurations                       = local.nat_ip_configurations
  tags                                        = var.tags
}