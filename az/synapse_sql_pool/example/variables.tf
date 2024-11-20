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
  default     = 5
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
  default = {
    Platform    = "azure"
    Environment = "example"
    Target      = "module"
  }
}