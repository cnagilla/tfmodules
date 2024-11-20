variable "name" {
  type        = string
  description = "Resource name"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "deployment_mode" {
  type        = string
  description = "Deployment mode"
  default     = "Incremental"
  validation {
    condition     = contains(["Incremental", "Complete"], var.deployment_mode)
    error_message = "Deployment mode must be one of Complete or Incremental."
  }
}

variable "parameters_content" {
  type        = string
  description = "Parameters JSON"
  default     = null
}

variable "template_content" {
  type        = string
  description = "Template JSON"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}