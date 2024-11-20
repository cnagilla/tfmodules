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

variable "cidrs" {
  type        = list(string)
  description = "List of CIDRs"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}
