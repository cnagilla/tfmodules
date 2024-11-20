variable "name" {
  type        = string
  description = "Resource name"
}

variable "cdn_frontdoor_profile_id" {
  type        = string
  description = "Front door profile ID"
}

variable "session_affinity_enabled" {
  type        = bool
  description = "Enable session affinity"
  default     = true
}

variable "restore_traffic_time_to_healed_or_new_endpoint_in_minutes" {
  type        = number
  description = "Minutes before shifting traffic to another endpoint"
  default     = 10
}

variable "lb" {
  type        = any
  description = "Load balancing configuration"
}

variable "health_probe" {
  type        = any
  description = "Health probe configuration"
  default     = {}
}