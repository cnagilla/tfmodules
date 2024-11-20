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

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether public network access is allowed for the container registry. Defaults to true"
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}