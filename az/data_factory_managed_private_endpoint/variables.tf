variable "name" {
  type        = string
  description = "Resource name"
}

variable "data_factory_id" {
  type        = string
  description = "Data factory ID"
}

variable "target_resource_id" {
  type        = string
  description = "Target resource ID"
}

variable "subresource_name" {
  type        = string
  description = "Target subresource name"
  default     = null
}