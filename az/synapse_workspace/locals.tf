locals {
  random_name                      = var.use_random_name ? (var.random_name_prefix != "" ? "${var.random_name_prefix}-${random_string.this[0].result}" : "synapse-${random_string.this[0].result}") : ""
  name                             = var.use_random_name ? local.random_name : var.name
  sql_administrator_login_password = var.sql_administrator_login_password != "" ? var.sql_administrator_login_password : random_password.this[0].result
}