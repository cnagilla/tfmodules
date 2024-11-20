locals {
  locations = {
    "cus" : "centralus"
    "eus2" : "eastus2"
  }
  vnet = {
    "cus" : {
      "cidr" : ["10.0.0.0/16"]
      "subnet" : ["10.0.1.0/24"]
    }
    "eus2" : {
      "cidr" : ["10.10.0.0/16"]
      "subnet" : ["10.10.1.0/24"]
    }
  }
  georeplications = {
    "eus2" : {
      location                = local.locations["eus2"]
      zone_redundancy_enabled = true
      tags                    = var.tags
    }
  }
}