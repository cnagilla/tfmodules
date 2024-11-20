resource "random_string" "this" {
  length  = var.random_string_length
  special = false
  upper   = false
}

resource "azurerm_servicebus_namespace" "this" {
  name                = "${var.name_prefix}-${random_string.this.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  capacity            = var.capacity
  tags                = var.tags
}

resource "azurerm_servicebus_topic" "this" {
  for_each = var.topics

  name         = try(each.value["name"], "sbt${local.middle_name}${each.key}")
  namespace_id = azurerm_servicebus_namespace.this.id
}

resource "azurerm_servicebus_queue" "this" {
  for_each = var.queues

  name         = try(each.value["name"], "sbq${local.middle_name}${each.key}")
  namespace_id = azurerm_servicebus_namespace.this.id
}

resource "azurerm_servicebus_subscription" "this" {
  for_each = local.subscriptions

  name               = try(each.value["name"], "sbts${local.middle_name}${each.key}")
  topic_id           = each.value["topic_id"]
  max_delivery_count = each.value["max_delivery_count"]
}

module "diagnostic" {
  for_each = var.diagnostic
  source   = "../diagnostic_setting"

  name                           = each.value["name"]
  target_resource_id             = azurerm_servicebus_namespace.this.id
  log_analytics_workspace_id     = each.value["log_analytics_workspace_id"]
  log_analytics_destination_type = try(each.value["log_analytics_destination_type"], null)
  log_categories                 = each.value["log_categories"]
}