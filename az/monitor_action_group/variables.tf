variable "name" {
  type        = string
  description = "Resource name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "short_name" {
  type        = string
  description = "Short name"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}