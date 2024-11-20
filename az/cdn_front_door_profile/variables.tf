variable "name" {
  type        = string
  description = "Resource name"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "response_timeout_seconds" {
  type        = number
  description = "Response timeout"
  default     = 120
}

variable "sku_name" {
  type        = string
  description = "SKU type"
  validation {
    condition     = contains(["Standard_AzureFrontDoor", "Premium_AzureFrontDoor"], var.sku_name)
    error_message = "SKU must be one of Standard_AzureFrontDoor or Premium_AzureFrontDoor."
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