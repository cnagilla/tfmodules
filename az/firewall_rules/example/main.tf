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

resource "azurerm_firewall_policy" "this" {
  name                = "fwpol-${var.name}-${random_string.this.result}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}

module "firewall_rules" {
  source = "../../firewall_rules"

  firewall_policy_id        = azurerm_firewall_policy.this.id
  firewall_rule_collections = local.fw_policy_rules
}