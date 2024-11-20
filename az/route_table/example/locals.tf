locals {
  routes = {
    "to-local-subnet" : {
      "name" : "rt-${var.name}-${random_string.this.result}-to-local-sub"
      "address_prefix" : azurerm_subnet.vm.address_prefixes[0],
      "next_hop_type" : "VnetLocal"
    }
  }
}