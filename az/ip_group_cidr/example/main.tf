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

resource "azurerm_ip_group" "this" {
  name                = "ipgrp-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

module "ip_group_cidr" {
  source = "../../ip_group_cidr"

  ip_group_id = azurerm_ip_group.this.id
  cidr        = "192.168.0.0/24"
}