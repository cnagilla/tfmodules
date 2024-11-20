variable "name" {
  type        = string
  description = "Resource name"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "private_dns_zone_name" {
  type        = string
  description = "Private DNS zone name"
}

variable "virtual_network_id" {
  type        = string
  description = "Linked virtual network ID"
}

variable "registration_enabled" {
  type        = bool
  description = "Allow auto-registration"
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}