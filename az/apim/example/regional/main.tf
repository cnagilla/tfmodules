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
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags
}

resource "azurerm_subnet" "apim" {
  name                 = "snet-${var.name}-${random_string.this.result}-apim"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "this" {
  name                = "nsg-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags
}

resource "azurerm_network_security_rule" "this" {
  for_each = local.nsg

  name                        = each.key
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.this.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = try(each.value.src_port_range, null)
  destination_port_range      = try(each.value.dest_port_range, null)
  destination_port_ranges     = try(each.value.dest_port_ranges, null)
  source_address_prefix       = try(each.value.src_prefix, null)
  destination_address_prefix  = try(each.value.dest_prefix, null)
}

resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = azurerm_subnet.apim.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_public_ip" "this" {
  name                = "pip-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "pip-${var.name}-${random_string.this.result}"
  tags                = var.tags
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
  application_type    = "other"
  workspace_id        = azurerm_log_analytics_workspace.this.id
  tags                = var.tags
}

module "apim" {
  source = "../../../apim"

  name_prefix          = "apim"
  location             = azurerm_resource_group.this.location
  resource_group_name  = azurerm_resource_group.this.name
  subnet_id            = azurerm_subnet.apim.id
  logger               = local.logger
  diagnostic           = local.diagnostic
  publisher_email      = "devops@example.com"
  publisher_name       = "DevOps"
  virtual_network_type = "Internal"
  sku_name             = "Developer_1"
  identity             = local.identity
  public_ip_address_id = azurerm_public_ip.this.id
  tags                 = var.tags
}