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

variable "public_network_access_enabled" {
  type        = bool
  description = "Server public access"
  default     = true
}

variable "storage_authentication_type" {
  type        = string
  description = "Storage auth type"
  default     = "System"
  validation {
    condition     = contains(["ManagedIdentity", "System"], var.storage_authentication_type)
    error_message = "Storage auth type can be one of 'ManagedIdentity' or 'System'."
  }
}

variable "storage_accounts" {
  type        = any
  description = "Storage account configuration"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}