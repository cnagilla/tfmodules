variable "name" {
  type        = string
  description = "Helm release name"
}
variable "namespace" {
  type        = string
  description = "Release namespace"
  default     = "default"
}

variable "create_namespace" {
  type        = bool
  description = "Create namespace"
  default     = false
}

variable "repository" {
  type        = string
  description = "Chart repository"
  default     = null
}

variable "chart" {
  type        = string
  description = "Chart name"
}

variable "chart_version" {
  type        = string
  description = "Chart version"
  default     = null
}

variable "timeout_seconds" {
  type        = number
  description = "Chart deployment timeout"
  default     = 600
}

variable "values" {
  type        = any
  description = "Chart raw yaml values"
  default     = ""
}

variable "parameters" {
  type        = any
  description = "Helm chart parameters to overwrite"
  default     = {}
}

variable "sensitive_parameters" {
  type        = any
  description = "Helm chart secret parameters to overwrite"
  default     = {}
}

variable "cleanup_on_fail" {
  type        = bool
  description = "Allow deletion of new resources created in this upgrade when upgrade fails"
  default     = true
}

variable "force_update" {
  type        = bool
  description = "Force resource update through delete/recreate if needed"
  default     = false
}