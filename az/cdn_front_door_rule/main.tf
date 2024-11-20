resource "azurerm_cdn_frontdoor_rule_set" "this" {
  name                     = var.rule_set_name
  cdn_frontdoor_profile_id = var.cdn_frontdoor_profile_id
}

resource "azurerm_cdn_frontdoor_rule" "this" {
  for_each = var.rules

  name                      = try(each.value["name"], "azfdrule-${each.key}")
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.this.id
  order                     = each.value["order"]
  behavior_on_match         = each.value["behavior_on_match"]

  actions {
    dynamic "route_configuration_override_action" {
      for_each = try(each.value["actions"]["route_configuration_override"], {})
      iterator = route_override

      content {
        cdn_frontdoor_origin_group_id = try(route_override.value["cdn_frontdoor_origin_group_id"], null)
        forwarding_protocol           = try(route_override.value["forwarding_protocol"], null)
        query_string_caching_behavior = try(route_override.value["query_string_caching_behavior"], null)
        query_string_parameters       = try(route_override.value["query_string_parameters"], null)
        compression_enabled           = try(route_override.value["compression_enabled"], null)
        cache_behavior                = try(route_override.value["cache_behavior"], null)
        cache_duration                = try(route_override.value["cache_duration"], null)
      }
    }

    dynamic "url_redirect_action" {
      for_each = try(each.value["actions"]["url_redirect"], {})
      iterator = url_redirect

      content {
        redirect_type        = try(url_redirect.value["redirect_type"], null)
        redirect_protocol    = try(url_redirect.value["redirect_protocol"], null)
        query_string         = try(url_redirect.value["query_string"], null)
        destination_path     = try(url_redirect.value["destination_path"], null)
        destination_hostname = try(url_redirect.value["destination_hostname"], null)
        destination_fragment = try(url_redirect.value["destination_fragment"], null)
      }
    }

    dynamic "response_header_action" {
      for_each = try(each.value["actions"]["response_header"], {})
      iterator = response_header

      content {
        header_action = try(response_header.value["header_action"], null)
        header_name   = try(response_header.value["header_name"], null)
        value         = try(response_header.value["value"], null)
      }
    }

    dynamic "url_rewrite_action" {
      for_each = try(each.value["actions"]["url_rewrite"], {})
      iterator = url_rewrite

      content {
        source_pattern          = try(url_rewrite.value["source_pattern"], null)
        destination             = try(url_rewrite.value["destination"], null)
        preserve_unmatched_path = try(url_rewrite.value["preserve_unmatched_path "], null)
      }
    }
  }

  conditions {
    dynamic "host_name_condition" {
      for_each = try(each.value["conditions"]["host_name"], {})
      iterator = host_name

      content {
        operator         = try(host_name.value["operator"], null)
        negate_condition = try(host_name.value["negate_condition"], null)
        match_values     = try(host_name.value["match_values"], null)
        transforms       = try(host_name.value["transforms"], null)
      }
    }

    dynamic "request_uri_condition" {
      for_each = try(each.value["conditions"]["request_uri"], {})
      iterator = request_uri

      content {
        operator         = try(request_uri.value["operator"], null)
        negate_condition = try(request_uri.value["negate_condition"], null)
        match_values     = try(request_uri.value["match_values"], null)
        transforms       = try(request_uri.value["transforms"], null)
      }
    }
  }
}