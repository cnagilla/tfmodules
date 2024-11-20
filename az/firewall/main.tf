resource "azurerm_firewall_policy" "this" {
  count = var.firewall_policy_name != "" ? 1 : 0

  name                = var.firewall_policy_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku_tier

  dynamic "insights" {
    for_each = var.insights

    content {
      enabled                            = true
      default_log_analytics_workspace_id = insights.value["log_analytics_workspace_id"]
      retention_in_days                  = try(insights.value["retention_in_days"], 30)
    }
  }

  dynamic "dns" {
    for_each = var.dns

    content {
      proxy_enabled = try(dns.value["proxy_enabled"], false)
      servers       = try(dns.value["servers"], [])
    }
  }

  tags = local.tags
}

resource "azurerm_firewall" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier
  firewall_policy_id  = var.firewall_policy_name != "" ? azurerm_firewall_policy.this[0].id : null


  dynamic "ip_configuration" {
    for_each = var.public_ips

    content {
      name                 = ip_configuration.value["public_ip_name"]
      public_ip_address_id = ip_configuration.value["public_ip_id"]
      subnet_id            = try(ip_configuration.value["subnet_id"], null)
    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      ip_configuration
    ]
  }
}

module "diagnostic" {
  for_each = var.diagnostic
  source   = "../diagnostic_setting"

  name                           = each.value["name"]
  target_resource_id             = azurerm_firewall.this.id
  log_analytics_workspace_id     = each.value["log_analytics_workspace_id"]
  log_analytics_destination_type = each.value["log_analytics_destination_type"]
  log_categories                 = each.value["log_categories"]
}