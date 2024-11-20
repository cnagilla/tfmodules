locals {
  api_connections = {
    "key_vault" : {
      "name" : "apicon-${var.name}-${random_string.this.result}-kv"
      "type" : "keyvault"
    }
    "service_bus" : {
      "name" : "apicon-${var.name}-${random_string.this.result}-sb"
      "type" : "servicebus"
    }
  }
  parameters = {
    "$connections" = jsonencode({
      "service_bus" : {
        "connectionId" : module.api_connection["service_bus"].id
        "connectionName" : module.api_connection["service_bus"].name
        "id" : module.api_connection["service_bus"].api_id
      }
      "key_vault" : {
        "connectionId" : module.api_connection["key_vault"].id
        "connectionName" : module.api_connection["key_vault"].name
        "id" : module.api_connection["key_vault"].api_id
      }
    })
  }
  workflow_parameters = {
    "$connections" = jsonencode({
      defaultValue = {}
      type         = "Object"
    })
  }
}