variable "length" {
  type        = number
  description = "Length"
  default     = 32
}

variable "override_special" {
  type        = string
  description = "Use only next special characters"
  default     = "!#%_-"
}