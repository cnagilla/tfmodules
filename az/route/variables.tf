variable "name" {
  type        = string
  description = "Resource name"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "route_table_name" {
  type        = string
  description = "Routing table name"
}

variable "address_prefix" {
  type        = string
  description = "Destination route"
}

variable "next_hop_type" {
  type        = string
  description = "Azure hop name"
}

variable "next_hop_in_ip" {
  type        = string
  description = "Next hop IP address in case VirtualAppliance"
  default     = null
}