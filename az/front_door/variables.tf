variable "name" {
  type        = string
  description = "Resource name"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "config" {
  type        = any
  description = "Frontdoor configuration"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}