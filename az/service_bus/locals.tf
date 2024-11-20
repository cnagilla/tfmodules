locals {
  middle_name = var.middle_name == "" ? "-" : "-${var.middle_name}-"
  subscriptions = merge([
    for topic, topic_cfg in var.topics : {
      for subscription, subscription_cfg in try(topic_cfg["subscriptions"], {}) :
      "${topic}_${subscription}" => merge(
        subscription_cfg,
        {
          "topic_id" : azurerm_servicebus_topic.this[topic].id
        }
      )
    }
  ]...)
}