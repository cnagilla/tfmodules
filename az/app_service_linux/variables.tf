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

variable "service_plan_id" {
  type        = string
  description = "Service plan"
}

variable "site_config" {
  type        = any
  description = "Site configuration"
  default = {
    main = {
      always_on = false
    }
  }
}

variable "identities" {
  type        = map(any)
  description = "Managed Service Identities"
  default     = {}
}

variable "virtual_network_subnet_id" {
  type        = string
  description = "Subnet ID for network integration"
  default     = null
}

variable "app_settings" {
  type        = map(string)
  description = "App config settings"
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