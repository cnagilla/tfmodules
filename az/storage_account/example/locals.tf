locals {
  file_shares = {
    "first" : {
      "name" : "share-${var.name}-${random_string.this.result}-first"
      "quota" : 500
    }
    "next" : {
      "quota" : 50
    }
  }
  containers = {
    "first" : {
      "name" : "stact-${var.name}-${random_string.this.result}-first"
      "access_type" : "private"
    }
    "second" : {
      "access_type" : "private"
      "metadata" : {
        "key" : "value"
      }
    }
  }
  net_rules = {
    "default" : {
      "default_action" : "Allow",
      "ip_rules" : ["100.0.0.1"],
      "virtual_network_subnet_ids" : [azurerm_subnet.this.id]
    }
  }
  identity = {
    "default" : {
      "type" : "SystemAssigned"
    }
  }
  diagnostic = {
    "default" : {
      "name" : "diag-${var.name}-${random_string.this.result}-sta",
      "log_analytics_workspace_id" : azurerm_log_analytics_workspace.this.id,
      "metric_categories" : {
        "Transaction" : {}
      }
    }
  }
}