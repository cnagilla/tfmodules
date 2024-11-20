locals {
  diagnostic = {
    "default" : {
      "name" : "diag-${var.name}-${random_string.this.result}-fw",
      "log_analytics_workspace_id" : azurerm_log_analytics_workspace.this.id,
      "log_analytics_destination_type" : "Dedicated",
      "log_categories" : {
        "AzureFirewallNetworkRule" : {},
        "AZFWNetworkRule" : {}
      }
    }
  }
  public_ips = {
    "primary" : {
      "name" : "pip-${var.name}-${random_string.this.result}-primary"
    },
    "secondary" : {
      "name" : "pip-${var.name}-${random_string.this.result}-secondary"
    }
  }
  dns = {
    "default" : {
      "proxy_enabled" : true
    }
  }
  fw_ips = {
    "primary" : {
      "public_ip_name" : azurerm_public_ip.this["primary"].name,
      "public_ip_id" : azurerm_public_ip.this["primary"].id
      "subnet_id" : azurerm_subnet.firewall.id
    },
    "secondary" : {
      "public_ip_name" : azurerm_public_ip.this["secondary"].name,
      "public_ip_id" : azurerm_public_ip.this["secondary"].id
    }
  }
}