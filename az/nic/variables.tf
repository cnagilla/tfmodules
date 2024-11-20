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

variable "enable_ip_forwarding" {
  type        = bool
  description = "Enable IP Forwarding"
  default     = false
}

variable "ip_configuration" {
  type        = any
  description = "IP configuration"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}