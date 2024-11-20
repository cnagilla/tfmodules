variable "name" {
  type        = string
  description = "Resource name"
}

variable "target_resource_id" {
  type        = string
  description = "Target resource"
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Log analytics workspace"
  default     = null
}

variable "log_categories" {
  type        = any
  description = "Diagnostic log categories"
  default     = {}
}

variable "metric_categories" {
  type        = any
  description = "Diagnostic metric categories"
  default     = {}
}

variable "log_analytics_destination_type" {
  type        = string
  description = "Log analytics destination type"
  default     = null
}