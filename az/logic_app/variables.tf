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

variable "enabled" {
  type        = bool
  description = "Turn on/off"
  default     = true
}

variable "parameters" {
  type        = any
  description = "Parameters"
  default     = {}
}

variable "workflow_parameters" {
  type        = any
  description = "Workflow parameters"
  default     = {}
}

variable "identity" {
  type        = map(any)
  description = "Managed Service Identities"
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}