locals {
  public_ips = {
    "pip1" : {
      "name" : "pip-${var.name}-${random_string.this.result}-01",
      "fw_association_vnet" : azurerm_virtual_network.this.name
    },
    "pip2" : {
      "name" : "pip-${var.name}-${random_string.this.result}-02"
    }
  }
}