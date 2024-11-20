data "azurerm_client_config" "current" {}

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
}

resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "this" {
  for_each = local.public_ips

  name                = each.value["name"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "this" {
  name                = "fw-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  lifecycle {
    ignore_changes = [
      ip_configuration
    ]
  }
}

module "firewall_ip" {
  for_each = local.public_ips
  source   = "../../firewall_ip"

  firewall_name       = azurerm_firewall.this.name
  resource_group_name = azurerm_resource_group.this.name
  subscription        = data.azurerm_client_config.current.subscription_id
  public_ip_name      = each.value["name"]
  vnet_name           = try(each.value["fw_association_vnet"], "")

  depends_on = [azurerm_public_ip.this, azurerm_subnet.firewall]
}