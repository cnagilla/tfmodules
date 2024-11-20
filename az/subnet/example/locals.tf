locals {
  subnets = {
    "api" : {
      "cidr" : "10.0.0.0/24"
    },
    "sql" : {
      "cidr" : "10.0.1.0/24",
      "delegations" : {
        "mssql" : {
          "name" : "Microsoft.Sql/managedInstances",
          "actions" : [
            "Microsoft.Network/virtualNetworks/subnets/join/action",
            "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
            "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
          ]
        }
      }
    },
    "firewall" : {
      "cidr" : "10.0.2.0/24",
      "name" : "AzureFirewallSubnet"
    },
    "bastion" : {
      "cidr" : "10.0.3.0/24",
      "name" : "AzureBastionSubnet"
    },
    "management" : {
      "cidr" : "10.0.4.0/24",
      "service_endpoints" : ["Microsoft.KeyVault"]
    },
    "pep" : {
      "cidr" : "10.0.5.0/24",
      "enforce_private_link_endpoint" : true
    },
    "svc" : {
      "cidr" : "10.0.6.0/24",
      "enforce_private_link_service" : true
    }
  }
}