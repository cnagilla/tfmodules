variable "app_config_id" {
  type        = string
  description = "App config ID"
}

variable "key" {
  type        = string
  description = "Key"
}

variable "label" {
  type        = string
  description = "Label"
  default     = null
}

variable "value" {
  type        = string
  description = "Value"
  default     = null
}

variable "type" {
  type        = string
  description = "Key type"
  default     = "kv"
  validation {
    condition     = contains(["kv", "vault"], var.type)
    error_message = "Key type must be one of 'kv' or 'vault'."
  }
}

variable "vault_key_reference" {
  type        = string
  description = "Vault key reference"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}