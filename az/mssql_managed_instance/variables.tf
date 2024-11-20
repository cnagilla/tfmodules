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

variable "sku_name" {
  type        = string
  description = "Pricing plan"
  default     = "GP_Gen5"
  validation {
    condition     = contains(["GP_Gen4", "GP_Gen5", "GP_Gen8IM", "GP_Gen8IH", "BC_Gen4", "BC_Gen5", "BC_Gen8IM", "BC_Gen8IH"], var.sku_name)
    error_message = "SKU Name for the SQL Managed Instance should be one of: GP_Gen4, GP_Gen5, GP_Gen8IM, GP_Gen8IH, BC_Gen4, BC_Gen5, BC_Gen8IM or BC_Gen8IH."
  }
}

variable "license_type" {
  type        = string
  description = "License type"
  default     = "LicenseIncluded"
  validation {
    condition     = contains(["LicenseIncluded", "BasePrice", ], var.license_type)
    error_message = "Managed Instance license should be one of: LicenseIncluded or BasePrice."
  }
}

variable "storage_size_in_gb" {
  type        = number
  description = "Storage size in gigabytes"
  default     = 32
  validation {
    condition     = var.storage_size_in_gb % 32 == 0
    error_message = "Storage size should be a multiple of 32."
  }
}

variable "subnet_id" {
  type        = string
  description = "Associated subnet ID"
}

variable "vcores" {
  type        = number
  description = "Number of CPU cores"
  default     = 4
}

variable "admin_login" {
  type        = string
  description = "Admin user name"
  default     = "msadmin"
}

variable "admin_password" {
  type        = string
  description = "Admin user password"
  default     = ""
}

variable "databases" {
  type        = map(any)
  description = "Databases"
  default     = {}
}

variable "databases_name_prefix" {
  type        = string
  description = "Databases name prefix"
  default     = "sqldb"
}

variable "random_string_length" {
  type        = number
  description = "Random string length used in resource name"
  default     = 5
}

variable "public_data_endpoint_enabled" {
  type        = bool
  description = "Public access enabled"
  default     = false
}

variable "identity" {
  type        = any
  description = "Identity type"
  default     = {}
}

variable "proxy_override" {
  type        = string
  description = "Access type"
  default     = "Default"
  validation {
    condition     = contains(["Default", "Proxy", "Redirect"], var.proxy_override)
    error_message = "SQL Managed Instance access type should be one of: Default, Proxy, or Redirect."
  }
}

variable "diagnostic" {
  type        = any
  description = "Diagnostic settings"
  default     = {}
}

variable "dns_zone_partner_id" {
  type        = string
  description = "DNS Zone ID"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}