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

variable "domain_name_label" {
  type        = string
  description = "FQDN for '<region>.cloudapp.azure.com' public domain"
  default     = null
}

variable "sku" {
  type        = string
  description = "IP pricing plan"
  default     = "Standard"
  validation {
    condition     = contains(["Basic", "Standard"], var.sku)
    error_message = "Load balancer pricing plan can be one of 'Basic' or 'Standard'."
  }
}

variable "allocation_method" {
  type        = string
  description = "How to allocate IP address"
  default     = "Static"
  validation {
    condition     = contains(["Static", "Dynamic"], var.allocation_method)
    error_message = "IP address can be allocated using Static or Dynamic way."
  }
}

variable "zones" {
  type        = list(string)
  description = "IP availability zones"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}