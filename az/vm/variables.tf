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

variable "os_family" {
  type        = string
  description = "Operating system"

  validation {
    condition     = contains(["linux", "windows"], var.os_family)
    error_message = "Possible values are 'windows' or 'linux'."
  }
}

variable "admin_username" {
  type        = string
  description = "Admin user name"
}

variable "admin_password" {
  type        = string
  description = "Admin user password"
  default     = null
}

variable "admin_public_key" {
  type        = string
  description = "Admin user SSH public key"
  default     = null
}

variable "size" {
  type        = string
  description = "Virtual machine size"
  default     = "Standard_DS1_v2"
}

variable "disable_password_authentication" {
  type        = bool
  description = "Disable SSH access using password"
  default     = true
}

variable "custom_data" {
  type        = string
  description = "Instance init script"
  default     = null
}

variable "image" {
  type        = any
  description = "Instance image configuration"
}

variable "nic" {
  type        = any
  description = "Instance NIC configuration"
}

variable "disk" {
  type        = any
  description = "Instance disk configuration"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}