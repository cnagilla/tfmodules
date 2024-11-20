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

variable "sku" {
  type        = string
  description = "Load balancer pricing plan"
  default     = "Standard"
  validation {
    condition     = contains(["Basic", "Standard", "Gateway"], var.sku)
    error_message = "Load balancer pricing plan can be one of 'Basic', 'Standard' or 'Gateway'."
  }
}

variable "public_ip_name" {
  type        = string
  description = "Public IP address name prefix"
  default     = "pip"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}