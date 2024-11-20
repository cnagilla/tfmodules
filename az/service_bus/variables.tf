variable "name_prefix" {
  type        = string
  description = "Resource name prefix"
}

variable "middle_name" {
  type        = string
  description = "Resource middle name, like: 'stg-dev-cus'"
  default     = ""
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

variable "sku" {
  type        = string
  description = "Service bus namespace pricing plan"
  default     = "Standard"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "Service bus sku can be one of: Basic, Standard or Premium."
  }
}

variable "topics" {
  type        = any
  description = "Topics"
  default     = {}
}

variable "queues" {
  type        = any
  description = "Queues"
  default     = {}
}

variable "capacity" {
  type        = number
  description = "SKU capacity number"
  default     = 0
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