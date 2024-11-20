variable "name" {
  type        = string
  description = "Resource name"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "linked_networks" {
  type        = any
  description = "Linked virtual networks"
  default     = {}
}

variable "linked_vnets_name_prefix" {
  type        = string
  description = "Name prefix for linked virtual network resources"
  default     = "dnzlink"
}

variable "a_records" {
  type        = any
  description = "DNS A Records"
  default     = {}
}

variable "cname_records" {
  type        = any
  description = "DNS CNAME Records"
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}