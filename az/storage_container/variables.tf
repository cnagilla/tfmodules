variable "name" {
  type        = string
  description = "Resource name"
}

variable "storage_account_name" {
  type        = string
  description = "Storage account name"
}

variable "container_access_type" {
  type        = string
  description = "Container type"
  default     = "private"
  validation {
    condition     = contains(["blob", "container", "private"], var.container_access_type)
    error_message = "Container access type should be one of: blob, container or private."
  }
}

variable "metadata" {
  type        = map(string)
  description = "Container MetaData"
  default     = null
}