variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "zone_name" {
  type        = string
  description = "DNS zone name"
}

variable "a_records" {
  type        = any
  description = "DNS A Records"
  default     = {}
}

variable "cname_records" {
  type        = any
  description = "DNS CNAME Records"
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}