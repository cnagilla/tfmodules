resource "azurerm_firewall_policy_rule_collection_group" "this" {
  for_each = var.firewall_rule_collections

  name               = try(each.value["collection_group_name"], "azfwpolrcg-${each.key}")
  firewall_policy_id = var.firewall_policy_id
  priority           = each.value["priority"]

  dynamic "application_rule_collection" {
    for_each = try(each.value["app_collections"], {})
    iterator = app_coll

    content {
      name     = try(app_coll.value["name"], "azfwpolapprule-${app_coll.key}")
      priority = app_coll.value["priority"]
      action   = app_coll.value["action"]

      dynamic "rule" {
        for_each = app_coll.value["rules"]
        iterator = app_coll_rule

        content {
          name                  = app_coll_rule.key
          description           = try(app_coll_rule.value["description"], null)
          source_addresses      = try(app_coll_rule.value["source_addresses"], null)
          source_ip_groups      = try(app_coll_rule.value["source_ip_groups"], null)
          destination_addresses = try(app_coll_rule.value["destination_addresses"], null)
          destination_fqdns     = try(app_coll_rule.value["destination_fqdns"], null)
          destination_fqdn_tags = try(app_coll_rule.value["destination_fqdn_tags"], null)

          dynamic "protocols" {
            for_each = app_coll_rule.value["protocols"]
            iterator = app_coll_rule_protocol

            content {
              type = app_coll_rule_protocol.value["type"]
              port = app_coll_rule_protocol.value["port"]
            }
          }
        }
      }
    }
  }

  dynamic "network_rule_collection" {
    for_each = try(each.value["net_collections"], {})
    iterator = net_coll

    content {
      name     = try(net_coll.value["name"], "azfwpolnetrule-${net_coll.key}")
      priority = net_coll.value["priority"]
      action   = net_coll.value["action"]

      dynamic "rule" {
        for_each = net_coll.value["rules"]
        iterator = net_coll_rule

        content {
          name                  = try(net_coll_rule.value["name"], net_coll_rule.key)
          protocols             = net_coll_rule.value["protocols"]
          destination_ports     = net_coll_rule.value["destination_ports"]
          source_addresses      = try(net_coll_rule.value["source_addresses"], null)
          source_ip_groups      = try(net_coll_rule.value["source_ip_groups"], null)
          destination_addresses = try(net_coll_rule.value["destination_addresses"], null)
          destination_fqdns     = try(net_coll_rule.value["destination_fqdns"], null)
        }
      }
    }
  }

  dynamic "nat_rule_collection" {
    for_each = try(each.value["nat_collections"], {})
    iterator = nat_coll

    content {
      name     = try(nat_coll.value["name"], "azfwpolnatrule-${nat_coll.key}")
      priority = nat_coll.value["priority"]
      action   = nat_coll.value["action"]

      dynamic "rule" {
        for_each = nat_coll.value["rules"]
        iterator = nat_coll_rule

        content {
          name                = try(nat_coll_rule.value["name"], nat_coll_rule.key)
          protocols           = nat_coll_rule.value["protocols"]
          source_addresses    = try(nat_coll_rule.value["source_addresses"], null)
          source_ip_groups    = try(nat_coll_rule.value["source_ip_groups"], null)
          destination_ports   = try(nat_coll_rule.value["destination_ports"], null)
          destination_address = try(nat_coll_rule.value["destination_address"], null)
          translated_address  = try(nat_coll_rule.value["translated_address"], null)
          translated_port     = try(nat_coll_rule.value["translated_port"], null)
          translated_fqdn     = try(nat_coll_rule.value["translated_fqdn"], null)
        }
      }
    }
  }
}