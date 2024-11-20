resource "azurerm_kubernetes_cluster" "this" {
  name                              = var.name
  dns_prefix                        = var.dns_prefix
  location                          = var.location
  resource_group_name               = var.resource_group_name
  kubernetes_version                = var.kubernetes_version
  private_cluster_enabled           = var.private_cluster_enabled
  private_dns_zone_id               = var.private_dns_zone_id
  sku_tier                          = var.sku_tier
  role_based_access_control_enabled = var.enable_rbac
  azure_policy_enabled              = var.azure_policy_enabled
  oidc_issuer_enabled               = var.oidc_issuer_enabled

  default_node_pool {
    name                        = var.node_pool["name"]
    vm_size                     = var.node_pool["vm_size"]
    temporary_name_for_rotation = try(var.node_pool["temporary_name_for_rotation"], null)
    max_pods                    = try(var.node_pool["max_pods"], null)
    type                        = try(var.node_pool["type"], "VirtualMachineScaleSets")
    vnet_subnet_id              = try(var.node_pool["vnet_subnet_id"], null)
    enable_node_public_ip       = try(var.node_pool["enable_node_public_ip"], true)
    zones                       = try(var.node_pool["zones"], null)
    os_disk_size_gb             = try(var.node_pool["os_disk_size_gb"], null)
    node_labels                 = try(var.node_pool["node_labels"], null)
    enable_auto_scaling         = try(var.node_pool["auto_scaling"]["enabled"], false)
    max_count                   = try(var.node_pool["auto_scaling"]["max_count"], null)
    min_count                   = try(var.node_pool["auto_scaling"]["min_count"], null)
    node_count                  = try(var.node_pool["node_count"], 1)
    tags                        = var.tags
  }

  dynamic "maintenance_window_auto_upgrade" {
    for_each = var.maintenance_window_auto_upgrade
    iterator = mwaks

    content {
      day_of_week = mwaks.value["day_of_week"]
      duration    = mwaks.value["duration"]
      frequency   = mwaks.value["frequency"]
      interval    = mwaks.value["interval"]
      start_time  = mwaks.value["start_time"]
      utc_offset  = mwaks.value["utc_offset"]
    }
  }

  dynamic "oms_agent" {
    for_each = var.oms_agent

    content {
      log_analytics_workspace_id = oms_agent.value["log_analytics_workspace_id"]
    }
  }

  dynamic "ingress_application_gateway" {
    for_each = var.ingress_application_gateway
    iterator = app_gw

    content {
      gateway_id   = try(app_gw.value["gateway_id"], null)
      gateway_name = try(app_gw.value["gateway_name"], null)
      subnet_cidr  = try(app_gw.value["subnet_cidr"], null)
      subnet_id    = try(app_gw.value["subnet_id"], null)
    }
  }

  dynamic "network_profile" {
    for_each = var.network_profile

    content {
      network_plugin     = network_profile.value["network_plugin"]
      load_balancer_sku  = try(network_profile.value["load_balancer_sku"], "standard")
      docker_bridge_cidr = try(network_profile.value["docker_bridge_cidr"], null)
      service_cidr       = try(network_profile.value["service_cidr"], null)
      dns_service_ip     = try(network_profile.value["dns_service_ip"], null)
      outbound_type      = try(network_profile.value["outbound_type"], "loadBalancer")
    }
  }

  dynamic "linux_profile" {
    for_each = var.linux_profile

    content {
      admin_username = linux_profile.value["admin_username"]

      ssh_key {
        key_data = linux_profile.value["admin_key"]
      }
    }
  }

  dynamic "key_vault_secrets_provider" {
    for_each = var.key_vault_secrets_provider
    iterator = kv_provider

    content {
      secret_rotation_enabled = kv_provider.value["secret_rotation_enabled"]
    }
  }

  dynamic "identity" {
    for_each = var.identity

    content {
      type         = identity.value["type"]
      identity_ids = try(identity.value["identity_ids"], null)
    }
  }

  dynamic "api_server_access_profile" {
    for_each = var.api_server_access_profile
    iterator = api_profile

    content {
      authorized_ip_ranges = try(api_profile.value["authorized_ip_ranges"], [])
    }
  }

  timeouts {
    create = try(var.timeouts["create"], "90m")
    delete = try(var.timeouts["delete"], "90m")
  }

  tags = var.tags
}
