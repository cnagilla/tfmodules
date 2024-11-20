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

variable "public_network_enabled" {
  type        = bool
  description = "Enable public access"
  default     = true
}

variable "managed_virtual_network_enabled" {
  type        = bool
  description = "Enable Managed Virtual Network"
  default     = false
}

variable "identities" {
  type        = map(any)
  description = "Managed Service Identities"
  default     = {}
}

variable "github_configuration" {
  type        = map(any)
  description = "Github configuration"
  default     = {}
}

variable "diagnostic" {
  type        = any
  description = "Diagnostic settings"
  default     = {}
}

variable "global_parameter" {
  type        = any
  description = "Global parameter settings"
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}