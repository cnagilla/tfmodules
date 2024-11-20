locals {
  storage_accounts = {
    "primary" : {
      "id" : azurerm_storage_account.this.id
      "is_primary" : true
      #      "managed_identity" : {
      #        "default" : {
      #          "use_system_assigned_identity" : true
      #        }
      #      }
    }
  }
}