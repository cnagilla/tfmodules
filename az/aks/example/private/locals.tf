locals {
  k8s_version = "1.25.5"
  node_pool = {
    "name" : "default"
    "vm_size" : "Standard_DS2_v2"
    "node_count" : 3
    "max_pods" : 60
    "type" : "VirtualMachineScaleSets"
    "vnet_subnet_id" : azurerm_subnet.k8s.id
    "enable_node_public_ip" : false
    "zones" : [1, 2, 3]
    "os_disk_size_gb" : 100
    "enable_auto_scaling" : false
  }
  oms_agent = {
    "default" : {
      "log_analytics_workspace_id" : azurerm_log_analytics_workspace.this.id
    }
  }
  network_profile = {
    "default" : {
      "network_plugin" : "azure"
      "load_balancer_sku" : "standard"
      "docker_bridge_cidr" : "172.17.0.1/16"
      "service_cidr" : "10.1.0.0/24"
      "dns_service_ip" : "10.1.0.10"
    }
  }
  linux_profile = {
    "default" : {
      "admin_username" : "sysops"
      "admin_key" : "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/r8+LheVWRpjg87HN5geUg0quJO5DUqW5YiHVYd0cYSrDvztMkERPrfJDOW1wyk6DyR/LzJylxvwa/kUp1ES/R/WA1ezw+TQyGxDZx3HI9nVT5Vas900NKTpQ4qXu5hWdHqhAPot5gP+HIvwiKV3rv5JEGhJwuwKH57hP3/a91BKAtKnoJL0KOoAXyVgJ/63XGVw0QrYnnHNvrGCpkZj3oUtWLtrrlou9nSFVQnak7KfUyQRU7fMPmfZAZg6ye623qmYB/OSqXdwqvggStxAWUERtIFuV68MHYo/T67GxYuDqJKbDyJaV+6JWzFhU1LtNOjQVaLMljJmI0gnip4FBO24utFUDMjJGDgcqJqOn0f4OfJTRBIik1BcEzubsqVBqIbJjQGtdRDMR1YVcUYdlu3ULX2fwHUzdNmvos7hpKl0ca2xsx24VGDZnpE6wYFogH4VgHUM37fLZ5KnGo6h3unZxawvb00MUT11Tpru+5/KJxdjON6mSmyBoBtJcSjL7a7pmFDFpYpxw5JR6L/tGKOncUChT/zx83xRsM/izbLG3YIfQUV5bWPh361dh5Xz7cnANxDpiMkHbwpXBdncLTirIAW6yeqZ0PU9EnWfoYX4+2sgdYn5USBV5SYTC9d1VE0dq8oL0YY81FG6qknLymxayxWS5GZP4kNvq44sTTQ=="
    }
  }
  identity = {
    "default" : {
      "type" : "UserAssigned"
      "identity_ids" : [azurerm_user_assigned_identity.k8s.id]
    }
  }
  rbac_cluster = {
    "aks-as-dns-contributor" : {
      "scope" : azurerm_private_dns_zone.k8s.id
      "role_definition_name" : "Private DNS Zone Contributor"
      "principal_id" : azurerm_user_assigned_identity.k8s.principal_id
    }
    "aks-as-network-contributor" : {
      "scope" : azurerm_virtual_network.this.id
      "role_definition_name" : "Network Contributor"
      "principal_id" : azurerm_user_assigned_identity.k8s.principal_id
    }
  }
}