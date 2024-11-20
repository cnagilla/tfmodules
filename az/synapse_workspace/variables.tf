variable "name" {
  type        = string
  description = "Exact resource name"
  default     = ""
}

variable "random_name_prefix" {
  type        = string
  description = "Prefix for random generated name"
  default     = ""
}

variable "use_random_name" {
  type        = bool
  description = "Generate random name"
  default     = false
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "random_string_length" {
  type        = number
  description = "Random string length used in resource name"
  default     = 5
}

variable "random_password_length" {
  type        = number
  description = "Random password length used in resource name"
  default     = 32
}

variable "storage_data_lake_gen2_filesystem_id" {
  type        = string
  description = "Storage lake ID"
}

variable "sql_administrator_login" {
  type        = string
  description = "SQL administrator login"
}

variable "sql_administrator_login_password" {
  type        = string
  description = "SQL administrator password"
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}