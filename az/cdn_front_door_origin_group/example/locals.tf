locals {
  origin_group = {
    "name" : "fdog-${var.name}-${random_string.this.result}",
    "restore_traffic_time_to_healed_or_new_endpoint_in_minutes" : 0,
    "load_balancing" : {
      "additional_latency_in_milliseconds" : 50,
      "sample_size" : 4,
      "successful_samples_required" : 3
    },
    "health_probe" : {
      "default" : {
        "protocol" : "Https",
        "request_type" : "HEAD",
        "path" : "/",
        "interval_in_seconds" : 60
      }
    }
  }
}