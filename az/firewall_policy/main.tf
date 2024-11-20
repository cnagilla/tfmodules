resource "azurerm_firewall_policy" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku

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
      proxy_enabled = dns.value["proxy_enabled"]
      servers       = dns.value["servers"]
    }
  }

  tags = local.tags
}