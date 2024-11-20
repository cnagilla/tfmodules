locals {
  nic = {
    "app-api-subnet" : {
      "name" : "nic-${var.name}-${random_string.this.result}-api",
      "ip_configuration" : {
        "primary" : {
          "name" : "nic-${random_string.this.result}-api01",
          "private_ip_address_allocation" : "Dynamic",
          "subnet_id" : azurerm_subnet.api.id,
          "primary" : true
        },
        "secondary" : {
          "name" : "nic-${var.name}-${random_string.this.result}-api02",
          "private_ip_address_allocation" : "Dynamic",
          "subnet_id" : azurerm_subnet.api.id
        }
      }
    }
    "app-vm-subnet" : {
      "name" : "nic-${var.name}-${random_string.this.result}-vm",
      "ip_configuration" : {
        "public" : {
          "private_ip_address_allocation" : "Dynamic",
          "public_ip_address_id" : azurerm_public_ip.this.id,
          "subnet_id" : azurerm_subnet.vm.id,
          "primary" : true
        }
      }
    }
  }
}