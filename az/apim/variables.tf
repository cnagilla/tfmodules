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

variable "domain_name_label" {
  type        = string
  description = "FQDN for '<region>.cloudapp.azure.com' public domain"
  default     = ""
}

variable "sku_name" {
  type        = string
  description = "Pricing plan"
  default     = "Developer_1"
}

variable "publisher_email" {
  type        = string
  description = "Publisher email address"
}

variable "publisher_name" {
  type        = string
  description = "Publisher name"
}

variable "random_string_length" {
  type        = number
  description = "Random string length used in resource name"
  default     = 5
}

variable "virtual_network_type" {
  type        = string
  description = "Virtual network type"
  default     = "None"
  validation {
    condition     = contains(["None", "Internal", "External"], var.virtual_network_type)
    error_message = "APIM virtual network can be on of: None, External or Internal."
  }
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID"
  default     = null
}

variable "public_ip_address_id" {
  type        = string
  description = "Associated public IP address ID"
  default     = null
}

variable "additional_location" {
  type        = any
  description = "Extra APIM location"
  default     = {}
}

variable "identity" {
  type        = map(any)
  description = "Managed Service Identities"
  default     = {}
}

variable "logger" {
  type        = any
  description = "Logging"
  default     = {}
}

variable "diagnostic" {
  type        = any
  description = "Diagnostic settings"
  default     = {}
}

variable "zones" {
  type        = any
  description = "Availability zones"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}