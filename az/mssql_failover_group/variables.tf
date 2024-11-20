variable "name_prefix" {
  type        = string
  description = "Resource name prefix"
}
variable "random_string_length" {
  type        = number
  description = "Random string length used in resource name"
  default     = 5
}
variable "location" {
  type        = string
  description = "Azure region"
}
variable "managed_instance_id" {
  type        = string
  description = "Primary instance id of sqlmi"
}
variable "partner_managed_instance_id" {
  type        = string
  description = "Secondary instance id of sqlmi"
}
variable "failover_mode" {
  type        = string
  description = "Automatic failover or manual failover"
}
variable "grace_period" {
  type        = string
  description = "Grace period for Manual failover"
  default     = "60"
}
variable "readonly_endpoint_failover_policy_enabled" {
  type        = string
  description = "True - DR is used only a read only copy. This would give us as discount of 55%"
  default     = true
}