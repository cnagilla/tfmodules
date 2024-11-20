resource "random_password" "this" {
  length           = var.length
  special          = true
  lower            = true
  upper            = true
  numeric          = true
  override_special = var.override_special
}