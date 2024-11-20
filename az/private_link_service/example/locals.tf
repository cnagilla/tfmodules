locals {
  nat_ip_configurations = {
    "primary" : {
      "name" : "pip-${var.name}-${random_string.this.result}-main",
      "primary" : true,
      "subnet_id" : azurerm_subnet.this.id,
      "private_ip_address" : "10.0.1.50"
    },
    "secondary" : {
      "name" : "pip-${var.name}-${random_string.this.result}-backup",
      "primary" : false,
      "subnet_id" : azurerm_subnet.this.id
    }
  }
}