resource "random_string" "this" {
  length  = var.random_string_length
  special = false
  upper   = false
}

module "rg" {
  source = "../../resource_group"

  name     = "rg-${var.name}-${random_string.this.result}"
  location = var.location
  tags     = var.tags
}