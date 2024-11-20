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

variable "app_service_plan_id" {
  type        = string
  description = "ID for service plan"
}

variable "storage_account_name" {
  type        = string
  description = "The backend storage account name"
}

variable "storage_account_access_key" {
  type        = string
  description = "Related storage account access key"
}

variable "virtual_network_subnet_id" {
  type        = string
  description = "Virtual network subnet used for the function"
  default     = null
}

variable "app_settings" {
  type        = map(string)
  description = "App config settings"
  default     = {}
}

variable "site_config" {
  type        = any
  description = "Site config"
  default     = {}
}

variable "identities" {
  type        = map(any)
  description = "Managed Service Identities"
  default     = {}
}

variable "diagnostic" {
  type        = any
  description = "Diagnostic settings"
  default     = {}
}

variable "runtime_version" {
  type        = string
  description = "Runtime version"
  default     = "~4"
}

variable "https_only" {
  type        = bool
  description = "HTTPs only"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}