variable "name_prefix" {
  type        = string
  description = "Resource name prefix"
  validation {
    condition     = length(var.name_prefix) >= 3 && length(var.name_prefix) <= 24
    error_message = "Storage account name prefix must be between 3 and (24 - var.random_string_length) characters long."
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

variable "account_tier" {
  type        = string
  description = "Storage account tier"
  default     = "Standard"
  validation {
    condition     = contains(["Standard", "Premium"], var.account_tier)
    error_message = "Account tier must be one of Standard or Premium."
  }
}

variable "account_replication_type" {
  type        = string
  description = "Storage account replication type"
  default     = "LRS"
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.account_replication_type)
    error_message = "Storage account replication type should be one of: LRS, GRS, RAGRS, ZRS, GZRS or RAGZRS."
  }
}

variable "storage_containers" {
  type        = any
  description = "Storage account Blob containers"
  default     = {}
}

variable "containers_name_prefix" {
  type        = string
  description = "Storage account Blob containers name prefix"
  default     = "stact"
}

variable "storage_shares" {
  type        = any
  description = "Storage account File shares"
  default     = {}
}

variable "shares_name_prefix" {
  type        = string
  description = "Storage account File shares name prefix"
  default     = "share"
}

variable "random_string_length" {
  type        = number
  description = "Random string length used in resource name"
  default     = 5
}

variable "identities" {
  type        = map(any)
  description = "Managed Service Identities"
  default     = {}
}

variable "is_hns_enabled" {
  type        = bool
  description = "Enable hierarchical namespace"
  default     = false
}

variable "public_access" {
  type        = bool
  description = "Enable public network access"
  default     = true
}

variable "network_rules" {
  type        = any
  description = "Network access rules"
  default     = {}
}

variable "min_tls_version" {
  type        = string
  description = "Minimum supported TLS version"
  default     = "TLS1_2"
}

variable "enable_https_traffic_only" {
  type        = bool
  description = "Azure region"
  default     = true
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