variable "name" {
  type        = string
  description = "Resource name"
}

variable "cdn_frontdoor_origin_group_id" {
  type        = string
  description = "Origin group ID"
}

variable "host_name" {
  type        = string
  description = "Public IP of FQDN"
}

variable "certificate_name_check_enabled" {
  type        = bool
  description = "Check certificate name"
  default     = false
}

variable "http_port" {
  type        = number
  description = "HTTP port"
  default     = 80
}

variable "https_port" {
  type        = number
  description = "HTTPs port"
  default     = 443
}

variable "priority" {
  type        = number
  description = "Priority"
  default     = 1
}

variable "weight" {
  type        = number
  description = "Weight"
  default     = 1000
}

variable "origin_host_header" {
  type        = string
  description = "Host headers"
  default     = null
}

variable "enabled" {
  type        = bool
  description = "Activate origin"
  default     = true
}