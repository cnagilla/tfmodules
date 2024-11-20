variable "name" {
  type        = string
  description = "Resource name"
}

variable "cdn_frontdoor_profile_id" {
  type        = string
  description = "Front door profile ID"
}

variable "enabled" {
  type        = bool
  description = "Enable origin"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}