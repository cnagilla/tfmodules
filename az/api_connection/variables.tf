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

variable "display_name" {
  type        = string
  description = "Resource display name"
  default     = ""
}

variable "type" {
  type        = string
  description = "Resource type"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}