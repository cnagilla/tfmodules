locals {
  access_policies = {
    "this_object" : {
      "object_id" : data.azurerm_client_config.current.object_id,
      "secret_permissions" : ["Get", "Set", "Delete", "List", "Purge", "Recover", "Restore", "Backup"]
    }
  }
  network_acl = {
    "default" : {
      "bypass" : "AzureServices",
      "default_action" : "Allow",
      "ip_rules" : ["8.8.8.8"],
      "virtual_network_subnet_ids" : [azurerm_subnet.this.id]
    }
  }
  diagnostic = {
    "default" : {
      "name" : "diag-${var.name}-${random_string.this.result}-kv",
      "log_analytics_workspace_id" : azurerm_log_analytics_workspace.this.id,
      "log_categories" : {
        "AuditEvent" : {},
        "AzurePolicyEvaluationDetails" : {}
      }
    }
  }
}