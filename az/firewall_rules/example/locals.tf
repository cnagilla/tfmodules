locals {
  fw_policy_rules = {
    "default" : {
      "name" : "azfwpolrcg-${var.name}-${random_string.this.result}-main",
      "priority" : 100,
      "app_collections" : {
        "collection1" : {
          "name" : "azfwpolapprule-${var.name}-${random_string.this.result}-col1",
          "priority" : 500,
          "action" : "Deny",
          "rules" : {
            "AllowWeb" : {
              "description" : "Allow HTTP and HTTPs",
              "destination_fqdns" : ["*.microsoft.com"],
              "source_addresses" : ["10.0.0.1"],
              "protocols" : {
                "http" : {
                  "type" : "Http",
                  "port" : 80
                }
                "https" : {
                  "type" : "Https",
                  "port" : 443
                }
              }
            }
          }
        }
      },
      "net_collections" : {
        "collection1" : {
          "name" : "azfwpolnetrule-${var.name}-${random_string.this.result}-col1",
          "priority" : 400,
          "action" : "Deny",
          "rules" : {
            "AllowTcpUdp" : {
              "destination_ports" : ["80", "1000-2000"],
              "destination_addresses" : ["192.168.1.1", "192.168.1.2"],
              "source_addresses" : ["10.0.0.1"],
              "protocols" : ["TCP", "UDP"]
            }
          }
        }
      },
      "nat_collections" : {
        "collection1" : {
          "name" : "azfwpolnatrule-${var.name}-${random_string.this.result}-col1",
          "priority" : 300,
          "action" : "Dnat",
          "rules" : {
            "DnatHttp" : {
              "destination_ports" : ["80"],
              "destination_address" : "192.168.1.1",
              "source_addresses" : ["10.0.0.1", "10.0.0.2"],
              "protocols" : ["TCP", "UDP"],
              "translated_address" : "192.168.0.1",
              "translated_port" : "8080"
            },
            "DnatHttps" : {
              "destination_ports" : ["443"],
              "destination_address" : "192.168.1.1",
              "source_addresses" : ["10.0.0.1", "10.0.0.2"],
              "protocols" : ["TCP", "UDP"],
              "translated_address" : "192.168.0.1",
              "translated_port" : "8080"
            }
          }
        }
      }
    }
  }
}