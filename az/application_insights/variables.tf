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

variable "application_type" {
  type        = string
  description = "Type of application insights"
  validation {
    condition     = contains(["ios", "java", "MobileCenter", "Node.JS", "other", "phone", "store", "web"], var.application_type)
    error_message = "Application insights type should be one of: ios, java, MobileCenter, Node.JS, other, phone, store or web."
  }
}

variable "workspace_id" {
  type        = string
  description = "Related workspace ID"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}