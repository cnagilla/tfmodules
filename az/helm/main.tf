resource "helm_release" "this" {
  name             = var.name
  namespace        = var.namespace
  create_namespace = var.create_namespace
  repository       = var.repository
  chart            = var.chart
  version          = var.chart_version
  cleanup_on_fail  = var.cleanup_on_fail
  force_update     = var.force_update
  values           = [var.values]

  dynamic "set_sensitive" {
    for_each = var.sensitive_parameters
    iterator = param

    content {
      name  = param.value["name"]
      value = param.value["value"]
    }
  }

  dynamic "set" {
    for_each = var.parameters
    iterator = param

    content {
      name  = param.value["name"]
      value = param.value["value"]
    }
  }

  timeout = var.timeout_seconds
}