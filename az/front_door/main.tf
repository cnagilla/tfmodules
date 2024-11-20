resource "azurerm_frontdoor" "this" {
  name                = var.config["name"]
  resource_group_name = var.resource_group_name

  dynamic "frontend_endpoint" {
    for_each = var.config["frontend_endpoints"]
    iterator = fe

    content {
      name                         = fe.value["name"]
      host_name                    = fe.value["host_name"]
      session_affinity_enabled     = try(fe.value["session_affinity_enabled"], false)
      session_affinity_ttl_seconds = try(fe.value["session_affinity_ttl_seconds"], 0)
    }
  }

  dynamic "backend_pool" {
    for_each = var.config["backend_pools"]
    iterator = be_pool

    content {
      name                = be_pool.value["name"]
      load_balancing_name = be_pool.value["load_balancing"]["name"]
      health_probe_name   = be_pool.value["health_probe"]["name"]

      dynamic "backend" {
        for_each = be_pool.value["backends"]
        iterator = be_pool_be

        content {
          host_header = be_pool_be.value["host_header"]
          address     = be_pool_be.value["address"]
          http_port   = be_pool_be.value["http_port"]
          https_port  = be_pool_be.value["https_port"]
        }
      }
    }
  }

  dynamic "backend_pool_health_probe" {
    for_each = var.config["backend_pools"]
    iterator = be_pool_hp

    content {
      name                = be_pool_hp.value["health_probe"]["name"]
      path                = try(be_pool_hp.value["health_probe"]["path"], "/")
      protocol            = try(be_pool_hp.value["health_probe"]["protocol"], "Http")
      probe_method        = try(be_pool_hp.value["health_probe"]["probe_method"], "GET")
      interval_in_seconds = try(be_pool_hp.value["health_probe"]["interval_in_seconds"], 120)
    }
  }

  dynamic "backend_pool_load_balancing" {
    for_each = var.config["backend_pools"]
    iterator = be_pool_lb

    content {
      name = be_pool_lb.value["load_balancing"]["name"]
    }
  }

  dynamic "routing_rule" {
    for_each = var.config["routing_rules"]
    iterator = rr

    content {
      name               = rr.value["name"]
      frontend_endpoints = rr.value["frontend_endpoints"]
      accepted_protocols = try(rr.value["accepted_protocols"], ["Http"])
      patterns_to_match  = try(rr.value["patterns_to_match"], ["/*"])

      dynamic "forwarding_configuration" {
        for_each = try(rr.value["forwarding_configuration"], {})
        iterator = rr_forwarding

        content {
          backend_pool_name   = rr_forwarding.value["backend_pool_name"]
          forwarding_protocol = try(rr_forwarding.value["forwarding_protocol"], "HttpsOnly")
          cache_enabled       = try(rr_forwarding.value["cache_enabled"], false)
        }
      }

      dynamic "redirect_configuration" {
        for_each = try(rr.value["redirect_configuration"], {})
        iterator = rr_redirect

        content {
          redirect_type     = rr_redirect.value["redirect_type"]
          redirect_protocol = try(rr_redirect.value["redirect_protocol"], "MatchRequest")
          custom_path       = try(rr_redirect.value["custom_path"], "/")
        }
      }
    }
  }

  tags = var.tags
}