resource "azurerm_data_factory" "this" {
  name                            = var.name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  public_network_enabled          = var.public_network_enabled
  managed_virtual_network_enabled = var.managed_virtual_network_enabled

  dynamic "global_parameter" {
    for_each = var.global_parameter
    iterator = param

    content {
      name  = param.value["name"]
      type  = param.value["type"]
      value = param.value["value"]
    }
  }

  dynamic "identity" {
    for_each = var.identities

    content {
      type         = identity.value["type"]
      identity_ids = try(identity.value["identity_ids"], null)
    }
  }

  dynamic "github_configuration" {
    for_each = var.github_configuration
    iterator = github

    content {
      account_name    = github.value["account_name"]
      branch_name     = github.value["branch_name"]
      git_url         = github.value["git_url"]
      repository_name = github.value["repository_name"]
      root_folder     = github.value["root_folder"]
    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      global_parameter
    ]
  }
}

module "diagnostic" {
  for_each = var.diagnostic
  source   = "../diagnostic_setting"

  name                           = each.value["name"]
  target_resource_id             = azurerm_data_factory.this.id
  log_analytics_workspace_id     = each.value["log_analytics_workspace_id"]
  log_analytics_destination_type = try(each.value["log_analytics_destination_type"], null)
  log_categories                 = try(each.value["log_categories"], null)
  metric_categories              = try(each.value["metric_categories"], null)
}