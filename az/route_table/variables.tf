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

variable "disable_bgp_route_propagation" {
  type        = bool
  description = "Disable BGP routes propagation"
  default     = true
}

variable "routes" {
  type        = map(map(string))
  description = "Routing table routes"
  default     = {}
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs to associate routing table with"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}