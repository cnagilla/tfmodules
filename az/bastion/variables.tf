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
  description = "Network subnet ID associated with the interface"
}

variable "public_ip_name" {
  type        = string
  description = "Public ip address object name"
}

variable "sku" {
  type        = string
  description = "Pricing plan"
  default     = "Standard"
  validation {
    condition     = contains(["Basic", "Standard"], var.sku)
    error_message = "Pricing plan can be one of 'Basic' or 'Standard'."
  }
}

variable "public_ip_allocation_method" {
  type        = string
  description = "How to allocate IP address"
  default     = "Static"
  validation {
    condition     = contains(["Static", "Dynamic"], var.public_ip_allocation_method)
    error_message = "IP address can be allocated using Static or Dynamic way."
  }
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}