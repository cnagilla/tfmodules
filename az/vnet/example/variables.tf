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
  description = "Random string length used in resource name"
}

variable "virtual_networks" {
  type        = any
  description = "Virtual networks with subnets"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}