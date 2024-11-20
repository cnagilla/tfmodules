variable "rule_set_name" {
  type        = string
  description = "Rule set names"
}

variable "cdn_frontdoor_profile_id" {
  type        = string
  description = "Front door profile ID"
}

variable "rules" {
  type        = any
  description = "Front door profile ID"
}