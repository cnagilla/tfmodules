locals {
  rule_sets = {
    "dev" : {
      "name" : "fdruleset${var.name}${random_string.this.result}fqdn"
      "rules" : {
        "api_fqdn" : {
          "name" : "fdrule${var.name}${random_string.this.result}urlrewrite"
          "order" : 1
          "behavior_on_match" : "Continue"
          "actions" : {
            "url_redirect" : {
              "api_fqdn" : {
                "redirect_type" : "Moved"
                "redirect_protocol" : "Https"
                "destination_hostname" : "test.example.com"
              }
            }
          }
          "conditions" : {
            "host_name" : {
              "api_fqdn" : {
                "operator" : "Equal"
                "match_values" : ["test.example.com"]
                "transforms" : ["Lowercase"]
              }
            }
          }
        }
      }
    }
    "security_headers" : {
      "name" : "fdruleset${var.name}${random_string.this.result}sec"
      "rules" : {
        "api_fqdn" : {
          "name" : "fdrule${var.name}${random_string.this.result}contentsecpol"
          "order" : 1
          "behavior_on_match" : "Continue"
          "actions" : {
            "response_header" : {
              "scp" : {
                "header_action" : "Append"
                "header_name" : "Content-Security-Policy"
                "value" : "default-src 'none'"
              }
              "sts" : {
                "header_action" : "Append"
                "header_name" : "Strict-Transport-Security"
                "value" : "max-age=31536000"
              }
              "xfo" : {
                "header_action" : "Append"
                "header_name" : "X-Frame-Options"
                "value" : "DENY"
              }
              "xcto" : {
                "header_action" : "Append"
                "header_name" : "X-Content-Type-Options"
                "value" : "nosniff"
              }
              "rp" : {
                "header_action" : "Append"
                "header_name" : "Referrer-Policy"
                "value" : "same-origin"
              }
            }
          }
        }
      }
    }
    "sfui" : {
      "name" : "fdruleset${var.name}${random_string.this.result}sfui"
      "rules" : {
        "rewrite" : {
          "name" : "fdrule${var.name}${random_string.this.result}rewrite"
          "order" : 1
          "behavior_on_match" : "Continue"
          "actions" : {
            "url_rewrite" : {
              "sfui_path" : {
                "source_pattern" : "/sfui/"
                "destination" : "/"
                "preserve_unmatched_path" : false
              }
            }
          }
          "conditions" : {
            "request_uri" : {
              "contains_gld" : {
                "operator" : "Contains"
                "match_values" : ["test"]
              }
            }
          }
        }
      }
    }
  }
}