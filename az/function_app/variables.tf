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

variable "os_type" {
  type        = string
  description = "OS type for the App Service"
}

variable "service_plan_id" {
  type        = string
  description = "ID for service plan"
  default     = null
}

variable "storage_account_name" {
  type        = string
  description = "The backend storage account name"
}

variable "virtual_network_subnet_id" {
  type        = string
  description = "Virtual network subnet used for the function"
  default     = null
}

variable "functions_extension_version" {
  type        = string
  description = "Runtime version"
  default     = "~4"
}

variable "storage_account_access_key" {
  type        = string
  description = "Related storage account access key"
  default     = null
}

variable "identities" {
  type        = map(any)
  description = "Managed Service Identities"
  default     = {}
}

variable "app_settings" {
  type        = map(string)
  description = "Function app config settings"
  default     = {}
}

variable "site_config" {
  type        = any
  description = "Site config"
  default     = {}
}

variable "builtin_logging_enabled" {
  type        = bool
  description = "Builtin logging"
  default     = false
}

variable "client_certificate_mode" {
  type        = string
  description = "TLS mode"
  default     = "Optional"
}

variable "https_only" {
  type        = bool
  description = "HTTPs only"
  default     = false
}

variable "application_stack" {
  type        = any
  description = "Application stack configuration"
  default     = {}
}

variable "cors" {
  type        = any
  description = "CORS"
  default     = {}
}

variable "sticky_settings" {
  type        = any
  description = "Sticky settings"
  default     = {}
}

variable "ip_restrictions" {
  type        = any
  description = "Function IP restrictions"
  default     = {}
}

variable "diagnostic" {
  type        = any
  description = "Diagnostic settings"
  default     = {}
}

variable "connection_string" {
  type        = any
  description = "Connection string parameters"
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}