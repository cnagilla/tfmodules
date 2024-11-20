variable "scope" {
  type        = string
  description = "Scope"
}

variable "role_definition_name" {
  type        = string
  description = "Build-in role name"
  default     = ""
}

variable "principal_id" {
  type        = string
  description = "User, Group or Service Principal ID"
}