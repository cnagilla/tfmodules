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

variable "vnet_address_space" {
  type        = list(string)
  description = "Virtual network CIDR"
}

variable "subnets" {
  type        = any
  description = "Virtual network subnets"
  default     = {}
}

variable "subnets_name_prefix" {
  type        = string
  description = "Subnets name prefix"
  default     = "snet"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}