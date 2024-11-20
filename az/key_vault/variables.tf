variable "name_prefix" {
  type        = string
  description = "Resource name prefix"
  validation {
    condition     = length(var.name_prefix) >= 3 && length(var.name_prefix) <= 24
    error_message = "Combination of (name_prefix + random_string_length) must be between 3 and 24 characters long."
  }
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "tenant_id" {
  type        = string
  description = "AD tenant ID"
}

variable "sku_name" {
  type        = string
  description = "SKU type"
  default     = "standard"
  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "Key vault SKU must be one of standard or premium."
  }
}

variable "access_policies" {
  type        = any
  description = "Access policies for related object IDs"
  default     = {}
}

variable "random_string_length" {
  type        = number
  description = "Random string length used in resource name"
  default     = 5
}

variable "enable_rbac_authorization" {
  type        = bool
  description = "Enable RBAC authorization"
  default     = false
}

variable "network_acls" {
  type        = any
  description = "Firewalls and virtual network rules"
  default     = {}
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