variable "name_prefix" {
  type        = string
  description = "Prefix for random generated name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "random_string_length" {
  type        = number
  description = "Random string length used in resource name"
  default     = 5
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Enable public access"
  default     = true
}

variable "connectivity_logs_enabled" {
  type        = bool
  description = "Enable connectivity logs"
  default     = false
}

variable "sku_name" {
  type        = string
  description = "Pricing plan"
  validation {
    condition     = contains(["Free_F1", "Standard_S1", "Premium_P1"], var.sku_name)
    error_message = "SKU should be one of: Free_F1, Standard_S1 or Premium_P1."
  }
}

variable "sku_capacity" {
  type        = number
  description = "Capacity"
}

variable "service_mode" {
  type        = string
  description = "Service mode"
  default     = "Default"
  validation {
    condition     = contains(["Classic", "Default", "Serverless"], var.service_mode)
    error_message = "SKU should be one of: Classic, Default or Serverless."
  }
}

variable "serverless_connection_timeout_in_seconds" {
  type        = number
  default     = 30
  description = "Connection timeout time"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}