variable "name" {
  type        = string
  description = "Resource name"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "subnet_address_space" {
  type        = string
  description = "Virtual network subnet CIDR"
}

variable "virtual_network_name" {
  type        = string
  description = "Virtual network name"
}

variable "delegations" {
  type        = any
  description = "Subnet delegations"
  default     = {}
}

variable "enforce_private_link_endpoint" {
  type        = bool
  description = "Enable private link endpoint feature"
  default     = false
}

variable "enforce_private_link_service" {
  type        = bool
  description = "Enable private link service feature"
  default     = false
}

variable "service_endpoints" {
  type        = list(string)
  description = "Subnet service endpoints"
  default     = []
}