variable "name" {
  type        = string
  description = "Resource name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "rules" {
  type        = any
  description = "Security group rules"
  default     = {}
}

variable "subnet_ids_association" {
  type        = list(string)
  description = "Subnet IDs that should be associated with the security group"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}