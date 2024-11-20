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
  description = "Firewall SKU"
  default     = "Standard"
  validation {
    condition     = contains(["Standard", "Premium", "Basic"], var.sku)
    error_message = "SKU tier must be one of Basic, Standard or Premium."
  }
}

variable "insights" {
  type        = any
  description = "Insights"
  default     = {}
}

variable "dns" {
  type        = any
  description = "DNS proxy configuration"
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}