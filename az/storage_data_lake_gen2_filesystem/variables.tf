variable "name" {
  type        = string
  description = "Resource name"
}

variable "storage_account_id" {
  type        = string
  description = "Storage account ID"
}

variable "properties" {
  type        = map(string)
  description = "Properties base64 encoded"
  default     = {}
}