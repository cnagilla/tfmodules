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

variable "a_records" {
  type        = any
  description = "A records"
  default     = {}
}

variable "cname_records" {
  type        = any
  description = "CNAME records"
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}