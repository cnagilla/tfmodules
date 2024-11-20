variable "name" {
  type        = string
  description = "Secret name"
}

variable "value" {
  type        = string
  description = "Secret value"
}

variable "key_vault_id" {
  type        = string
  description = "Key vault ID"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}