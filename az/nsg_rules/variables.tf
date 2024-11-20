variable "network_security_group_name" {
  type        = string
  description = "Network security group name"
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