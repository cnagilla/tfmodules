locals {
  tags = tomap({ for key, val in var.tags : lower(key) => val })
}