locals {
  keys = {
    "db_user" : {
      "key" : "db_user",
      "type" : "kv",
      "value" : "sysops"
    },
    "db_password" : {
      "key" : "db_password",
      "type" : "vault",
      "vault_key_reference" : azurerm_key_vault_secret.db_password.versionless_id
    }
  }
}