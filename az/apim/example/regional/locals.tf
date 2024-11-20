locals {
  nsg = {
    "allow_api_management" : {
      "priority" : 100
      "direction" : "Inbound"
      "access" : "Allow"
      "protocol" : "Tcp"
      "src_port_range" : "*"
      "dest_port_range" : "3443"
      "src_prefix" : "ApiManagement"
      "dest_prefix" : "VirtualNetwork"
    }
    "allow_azure_lb" : {
      "priority" : 110
      "direction" : "Inbound"
      "access" : "Allow"
      "protocol" : "Tcp"
      "src_port_range" : "*"
      "dest_port_range" : "6390"
      "src_prefix" : "AzureLoadBalancer"
      "dest_prefix" : "VirtualNetwork"
    }
    "allow_azure_kv_out" : {
      "priority" : 120
      "direction" : "Outbound"
      "access" : "Allow"
      "protocol" : "Tcp"
      "src_port_range" : "*"
      "dest_port_range" : "443"
      "src_prefix" : "VirtualNetwork"
      "dest_prefix" : "AzureKeyVault"
    }
    "allow_azure_sta_out" : {
      "priority" : 130
      "direction" : "Outbound"
      "access" : "Allow"
      "protocol" : "Tcp"
      "src_port_range" : "*"
      "dest_port_range" : "443"
      "src_prefix" : "VirtualNetwork"
      "dest_prefix" : "Storage"
    }
    "allow_azure_sql_out" : {
      "priority" : 140
      "direction" : "Outbound"
      "access" : "Allow"
      "protocol" : "Tcp"
      "src_port_range" : "*"
      "dest_port_range" : "1433"
      "src_prefix" : "VirtualNetwork"
      "dest_prefix" : "SQL"
    }
    "allow_azure_monitor_out" : {
      "priority" : 150
      "direction" : "Outbound"
      "access" : "Allow"
      "protocol" : "Tcp"
      "src_port_range" : "*"
      "dest_port_ranges" : ["1886", "443"]
      "src_prefix" : "VirtualNetwork"
      "dest_prefix" : "AzureMonitor"
    }
  }
  identity = {
    "default" : {
      "type" : "SystemAssigned"
    }
  }
  diagnostic = {
    "default" : {
      "name" : "diag-${var.name}-${random_string.this.result}-apim"
      "log_analytics_workspace_id" : azurerm_log_analytics_workspace.this.id
      "log_analytics_destination_type" : "Dedicated"
      "log_categories" : {
        "GatewayLogs" : {}
      }
    }
  }
  logger = {
    "default" : {
      "name" : azurerm_application_insights.this.name
      "app_insights_id" : azurerm_application_insights.this.id
      "app_insights_instrumentation_key" : azurerm_application_insights.this.instrumentation_key
    }
  }
}