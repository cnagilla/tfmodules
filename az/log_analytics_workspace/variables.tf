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
  description = "Pricing tier"
  default     = "PerGB2018"
}

variable "retention_in_days" {
  type        = number
  description = "Data retention"
  default     = 30
  validation {
    condition     = var.retention_in_days >= 30 && var.retention_in_days <= 730
    error_message = "Accepted values: 30-730."
  }
}

variable "random_string_length" {
  type        = number
  description = "Random string length used in resource name"
  default     = 5
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}