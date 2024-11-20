variable "name_prefix" {
  type        = string
  description = "Resource name prefix"
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
  description = "SKU"
  default     = "standard"
  validation {
    condition     = contains(["standard", "free"], var.sku)
    error_message = "Key vault SKU must be one of standard or free."
  }
}

variable "random_string_length" {
  type        = number
  description = "Random string length used in resource name"
  default     = 5
}

variable "public_network_access" {
  type        = string
  description = "Public network access"
  default     = "Enabled"
  validation {
    condition     = contains(["Enabled", "Disabled"], var.public_network_access)
    error_message = "Public Network Access setting must be one of Disabled or Enabled."
  }
}

variable "diagnostic" {
  type        = any
  description = "Diagnostic settings"
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}