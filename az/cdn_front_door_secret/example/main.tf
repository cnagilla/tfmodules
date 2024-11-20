data "azurerm_client_config" "current" {}

data "http" "public_ip" {
  url = "https://ifconfig.co/json"
  request_headers = {
    Accept = "application/json"
  }
}

resource "random_string" "this" {
  length  = var.random_string_length
  special = false
  upper   = false
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${var.name}-${random_string.this.result}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_key_vault" "this" {
  name                       = "kv-${var.name}-${random_string.this.result}"
  location                   = azurerm_resource_group.this.location
  resource_group_name        = azurerm_resource_group.this.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "premium"
  soft_delete_retention_days = 7

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = ["${local.ifconfig_co_json.ip}/32"]
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = azurerm_user_assigned_identity.this.principal_id

    secret_permissions = [
      "Get",
    ]
  }

  # Terraform Service Principal
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id # <- Object Id of the Service Principal that Terraform is running as

    certificate_permissions = [
      "Get",
      "List",
      "Create",
      "Update",
      "Import",
      "Delete",
      "Purge"
    ]

    secret_permissions = [
      "Get",
    ]
  }
}

resource "azurerm_key_vault_certificate" "this" {
  name         = "kvcert-${var.name}-${random_string.this.result}"
  key_vault_id = azurerm_key_vault.this.id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      extended_key_usage = ["1.3.6.1.5.5.7.3.1"]

      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject_alternative_names {
        dns_names = ["internal.example-org.com", "domain.example-org.com"]
      }

      subject            = "CN=example-org"
      validity_in_months = 12
    }
  }
}

resource "azurerm_cdn_frontdoor_profile" "this" {
  name                = "fd-${var.name}-${random_string.this.result}"
  resource_group_name = azurerm_resource_group.this.name
  sku_name            = "Standard_AzureFrontDoor"
}

resource "azurerm_user_assigned_identity" "this" {
  name                = "id-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azapi_update_resource" "profile" {
  type        = "Microsoft.Cdn/profiles@2024-02-01"
  resource_id = azurerm_cdn_frontdoor_profile.this.id
  body = jsonencode({
    identity = {
      type = "UserAssigned"
      userAssignedIdentities = {
        (azurerm_user_assigned_identity.this.id) = {}
      }
    }
  })

  depends_on = [
    azurerm_user_assigned_identity.this,
    azurerm_cdn_frontdoor_profile.this
  ]
}


module "fd_secret" {
  source = "../../cdn_front_door_secret"

  name                     = "fdsec-${var.name}-${random_string.this.result}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id
  key_vault_certificate_id = azurerm_key_vault_certificate.this.id
}