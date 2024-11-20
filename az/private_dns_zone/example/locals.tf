locals {
  linked_networks = {
    "app" : {
      "name" : azurerm_virtual_network.app.name
      "id" : azurerm_virtual_network.app.id
      "registration_enabled" : false
    }
  }
  a_records = {
    "test" : {
      "name" : "api"
      "records" : ["192.168.1.234"]
      "ttl" : 600
    }
  }
  cname_records = {
    "test" : {
      "name" : "ui"
      "record" : "ui.example.com"
      "ttl" : 3600
    }
  }
}