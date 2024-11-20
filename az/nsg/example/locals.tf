locals {
  nsg = {
    "vm" : {
      "rules" : {
        "allow_rdp_ssh_inbound_from_bastion_subnet" : {
          "priority" : 100,
          "direction" : "Inbound",
          "access" : "Allow",
          "protocol" : "Tcp",
          "src_port_range" : "*",
          "dest_port_ranges" : ["3389", "22"],
          "src_prefix" : azurerm_subnet.bastion.address_prefixes[0],
          "dest_prefix" : "*"
        }
      },
      "subnet_ids_association" : [azurerm_subnet.vm.id]
    },
    "bastion" : {
      "rules" : {
        "allow_https_inbound" : {
          "priority" : 120,
          "direction" : "Inbound",
          "access" : "Allow",
          "protocol" : "Tcp",
          "src_port_range" : "*",
          "dest_port_range" : "443",
          "src_prefix" : "Internet",
          "dest_prefix" : "*"
        },
        "allow_gw_manager_inbound" : {
          "priority" : 130,
          "direction" : "Inbound",
          "access" : "Allow",
          "protocol" : "Tcp",
          "src_port_range" : "*",
          "dest_port_range" : "443",
          "src_prefix" : "GatewayManager",
          "dest_prefix" : "*"
        },
        "allow_azure_lb_inbound" : {
          "priority" : 140,
          "direction" : "Inbound",
          "access" : "Allow",
          "protocol" : "Tcp",
          "src_port_range" : "*",
          "dest_port_range" : "443",
          "src_prefix" : "AzureLoadBalancer",
          "dest_prefix" : "*"
        },
        "allow_bastion_host_inbound" : {
          "priority" : 150,
          "direction" : "Inbound",
          "access" : "Allow",
          "protocol" : "*",
          "src_port_range" : "*",
          "dest_port_ranges" : ["8080", "5701"],
          "src_prefix" : "VirtualNetwork",
          "dest_prefix" : "VirtualNetwork"
        },
        "allow_ssh_rdp_outbound" : {
          "priority" : 100,
          "direction" : "Outbound",
          "access" : "Allow",
          "protocol" : "*",
          "src_port_range" : "*",
          "dest_port_ranges" : ["22", "3389"],
          "src_prefix" : "*",
          "dest_prefix" : "VirtualNetwork"
        },
        "allow_bastion_host_outbound" : {
          "priority" : 120,
          "direction" : "Outbound",
          "access" : "Allow",
          "protocol" : "*",
          "src_port_range" : "*",
          "dest_port_ranges" : ["8080", "5701"],
          "src_prefix" : "VirtualNetwork",
          "dest_prefix" : "VirtualNetwork"
        },
        "allow_azure_cloud_outbound" : {
          "priority" : 110,
          "direction" : "Outbound",
          "access" : "Allow",
          "protocol" : "Tcp",
          "src_port_range" : "*",
          "dest_port_range" : "443",
          "src_prefix" : "*",
          "dest_prefix" : "AzureCloud"
        },
        "allow_get_session_info_outbound" : {
          "priority" : 130,
          "direction" : "Outbound",
          "access" : "Allow",
          "protocol" : "*",
          "src_port_range" : "*",
          "dest_port_range" : "80",
          "src_prefix" : "*",
          "dest_prefix" : "Internet"
        }
      },
      "subnet_ids_association" : [azurerm_subnet.bastion.id]
    }
  }
}