variable "name" {
  type        = string
  description = "Resource name"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "virtual_network_name" {
  type        = string
  description = "Local virtual network name"
}

variable "remote_virtual_network_id" {
  type        = string
  description = "Remote virtual network ID"
}

variable "allow_virtual_network_access" {
  type        = bool
  description = "Remote-to-Local VM access allow"
  default     = true
}

variable "allow_forwarded_traffic" {
  type        = bool
  description = "Remote-to-Local traffic forwarding allow"
  default     = false
}