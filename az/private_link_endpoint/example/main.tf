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

resource "azurerm_subnet" "service" {
  name                 = "snet-${var.name}-${random_string.this.result}-service"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.1.0/24"]

  enforce_private_link_service_network_policies = true
}

resource "azurerm_subnet" "endpoint" {
  name                 = "snet-${var.name}-${random_string.this.result}-endpoint"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.2.0/24"]

  enforce_private_link_endpoint_network_policies = true
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

resource "azurerm_private_link_service" "this" {
  name                = "pls-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  nat_ip_configuration {
    name      = azurerm_public_ip.this.name
    primary   = true
    subnet_id = azurerm_subnet.service.id
  }

  load_balancer_frontend_ip_configuration_ids = [azurerm_lb.this.frontend_ip_configuration.0.id]
}

resource "azurerm_app_configuration" "this" {
  name                = "appcfg-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "standard"
}

resource "azurerm_private_dns_zone" "service" {
  name                = "service-${var.name}-${random_string.this.result}.com"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone" "appcfg" {
  name                = "privatelink.azconfig.io"
  resource_group_name = azurerm_resource_group.this.name
}

module "private_endpoint" {
  for_each = local.private_endpoints
  source   = "../../private_link_endpoint"

  name                           = each.value["name"]
  location                       = azurerm_resource_group.this.location
  resource_group_name            = azurerm_resource_group.this.name
  private_connection_resource_id = each.value["target_resource_id"]
  subnet_id                      = azurerm_subnet.endpoint.id
  private_dns_zones              = each.value["private_dns_zones"]
  subresource_names              = try(each.value["target_subresource_names"], null)
  tags                           = var.tags
}