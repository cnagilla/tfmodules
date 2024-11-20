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

variable "subnet_id" {
  type        = string
  description = "Subnet ID for NAT IP configuration"
}

variable "private_connection_resource_id" {
  type        = string
  description = "Target resource ID for private link"
}

variable "is_manual_connection" {
  type        = bool
  description = "Manual or automated approval of resource owner"
  default     = false
}

variable "subresource_names" {
  type        = list(string)
  description = "Subresource names which the Private Endpoint is able to connect to"
  default     = null
}

variable "private_dns_zones" {
  type        = any
  description = "Private DNS zones group"
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}