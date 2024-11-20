locals {
  front_door_config = {
    "name" : "fd-${var.name}-${random_string.this.result}"
    "frontend_endpoints" : {
      "bing" : {
        "name" : "default",
        "host_name" : "fd-${var.name}-${random_string.this.result}.azurefd.net"
      }
    },
    "backend_pools" : {
      "bing" : {
        "name" : "bing",
        "health_probe" : {
          "name" : "bing-hp",
          "path" : "/"
          "protocol" : "Https"
          "probe_method" : "GET"
          "interval_in_seconds" : 120
        },
        "load_balancing" : {
          "name" : "bing-lb"
        }
        "backends" : {
          "default" : {
            "host_header" : "bing.com",
            "address" : "bing.com",
            "http_port" : 80,
            "https_port" : 443
          }
        }
      }
    },
    "routing_rules" : {
      "bing_https" : {
        "name" : "bing-https-rr",
        "frontend_endpoints" : ["default"],
        "accepted_protocols" : ["Https"],
        "patterns_to_match" : ["/*"],
        "forwarding_configuration" : {
          "default" : {
            "backend_pool_name" : "bing",
            "forwarding_protocol" : "MatchRequest",
            "cache_enabled" : true
          }
        }
      },
      "bing_http_to_https" : {
        "name" : "bing-http-to-https-rr",
        "frontend_endpoints" : ["default"],
        "accepted_protocols" : ["Http"],
        "patterns_to_match" : ["/*"],
        "redirect_configuration" : {
          "default" : {
            "redirect_protocol" : "HttpsOnly"
            "redirect_type" : "Found"
            "custom_path" : "/"
          }
        }
      }
    }
  }
}