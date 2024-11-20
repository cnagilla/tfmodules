variable "name" {
  type        = string
  description = "Resource name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "random_string_length" {
  type        = number
  description = "Random string length"
}

variable "public_network_enabled" {
  type        = bool
  description = "Enable public access"
}

variable "identities" {
  type        = map(any)
  description = "Managed Service Identities"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}