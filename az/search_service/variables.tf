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

variable "sku" {
  type        = string
  description = "Pricing plan"
  default     = "standard"
  validation {
    condition     = contains(["basic", "standard", "standard2", "standard3", "storage_optimized_l1", "storage_optimized_l2"], var.sku)
    error_message = "Pricing plan can be one of basic, free, standard, standard2, standard3, storage_optimized_l1 or storage_optimized_l2."
  }
}

variable "semantic_search_sku" {
  type        = string
  description = "Resource group name"
  default     = null
  validation {
    condition     = contains(["free", "standard"], var.semantic_search_sku)
    error_message = "Pricing search plan can be one of free and standard."
  }
}

variable "replica_count" {
  type        = number
  description = "Number of replicas"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}
