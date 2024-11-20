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

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}