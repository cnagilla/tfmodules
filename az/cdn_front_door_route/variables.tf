variable "name" {
  type        = string
  description = "Resource name"
}

variable "enabled" {
  type        = bool
  description = "Enable route"
  default     = true
}

variable "cdn_frontdoor_endpoint_id" {
  type        = string
  description = "Front door endpoint ID"
}

variable "cdn_frontdoor_origin_group_id" {
  type        = string
  description = "Front door origin group ID"
}

variable "cdn_frontdoor_origin_ids" {
  type        = list(string)
  description = "Front door origins"
}

variable "cdn_frontdoor_rule_set_ids" {
  type        = list(string)
  description = "Front door rule sets"
  default     = []
}

variable "forwarding_protocol" {
  type        = string
  description = "Backend forwarding protocol"
  validation {
    condition     = contains(["HttpOnly", "HttpsOnly", "MatchRequest"], var.forwarding_protocol)
    error_message = "Forwarding protocol must be one of HttpOnly, HttpsOnly or MatchRequest."
  }
}

variable "https_redirect_enabled" {
  type        = bool
  description = "Redirect to HTTPs"
  default     = true
}

variable "patterns_to_match" {
  type        = list(string)
  description = "Patterns to match"
}

variable "supported_protocols" {
  type        = list(string)
  description = "Supported protocols"
}

variable "cdn_frontdoor_custom_domain_ids" {
  type        = list(string)
  description = "Front door domains association"
}

variable "link_to_default_domain" {
  type        = bool
  description = "Link to default endpoint"
  default     = true
}

variable "cache" {
  type        = any
  description = "Cache configuration"
  default     = {}
}

variable "domain_association" {
  type        = list(string)
  description = "Custom domain IDs that should be associated with the route"
  default     = []
}