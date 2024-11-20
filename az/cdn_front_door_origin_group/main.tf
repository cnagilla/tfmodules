resource "azurerm_cdn_frontdoor_origin_group" "this" {
  name                                                      = var.name
  cdn_frontdoor_profile_id                                  = var.cdn_frontdoor_profile_id
  session_affinity_enabled                                  = var.session_affinity_enabled
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = var.restore_traffic_time_to_healed_or_new_endpoint_in_minutes

  load_balancing {
    additional_latency_in_milliseconds = var.lb["additional_latency_in_milliseconds"]
    sample_size                        = var.lb["sample_size"]
    successful_samples_required        = var.lb["successful_samples_required"]
  }

  dynamic "health_probe" {
    for_each = var.health_probe
    iterator = hp

    content {
      interval_in_seconds = hp.value["interval_in_seconds"]
      protocol            = hp.value["protocol"]
      path                = try(hp.value["path"], "/")
      request_type        = try(hp.value["request_type"], "HEAD")
    }
  }
}