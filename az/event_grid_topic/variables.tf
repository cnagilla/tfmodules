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

variable "public_network_access_enabled" {
  type        = bool
  description = "Public access enabled"
  default     = true
}

variable "diagnostic" {
  type        = any
  description = "Diagnostic settings"
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}