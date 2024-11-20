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

variable "nat_ip_configurations" {
  type        = map(any)
  description = "Private link service NAT IP configurations"
}

variable "nat_ip_configuration_name_prefix" {
  type        = string
  description = "Name prefix for NAT IP configurations"
  default     = "pip"
}

variable "load_balancer_frontend_ip_configuration_ids" {
  type        = list(string)
  description = "LB frontend IP configuration IDs"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}