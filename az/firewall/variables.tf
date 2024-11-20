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

variable "sku_tier" {
  type        = string
  description = "Firewall SKU tier"
  default     = "Standard"
  validation {
    condition     = contains(["Standard", "Premium"], var.sku_tier)
    error_message = "SKU tier must be one of Standard or Premium."
  }
}

variable "sku_name" {
  type        = string
  description = "Firewall SKU name"
  default     = "AZFW_VNet"
  validation {
    condition     = contains(["AZFW_Hub", "AZFW_VNet"], var.sku_name)
    error_message = "SKU name must be one of AZFW_Hub or AZFW_VNet."
  }
}

variable "firewall_policy_name" {
  type        = string
  description = "Firewall policy name"
  default     = ""
}

variable "public_ips" {
  type        = any
  description = "Firewall public IP addresses"
  default     = {}
}

variable "insights" {
  type        = any
  description = "Insights"
  default     = {}
}

variable "diagnostic" {
  type        = any
  description = "Diagnostic settings"
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