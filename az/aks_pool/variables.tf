variable "name" {
  type        = string
  description = "Resource name"
}

variable "kubernetes_cluster_id" {
  type        = string
  description = "Kubernetes cluster ID"
}

variable "vm_size" {
  type        = string
  description = "Node size"
}

variable "node_count" {
  type        = number
  description = "Number of nodes"
}

variable "mode" {
  type        = string
  description = "Usage type"
  default     = "User"
  validation {
    condition     = contains(["User", "System"], var.mode)
    error_message = "This pool should be used for System or User resources only."
  }
}

variable "max_pods" {
  type        = number
  description = "Max number of PODs per node"
  default     = 30
}

variable "vnet_subnet_id" {
  type        = string
  description = "Subnet ID"
  default     = null
}

variable "enable_node_public_ip" {
  type        = bool
  description = "Assign public IP for nodes"
  default     = false
}

variable "zones" {
  type        = list(number)
  description = "Availability zones"
  default     = [1, 2, 3]
}

variable "os_disk_size_gb" {
  type        = number
  description = "Disk size"
  default     = null
}

variable "node_labels" {
  type        = map(string)
  description = "Node labels"
  default     = {}
}

variable "enable_auto_scaling" {
  type        = bool
  description = "Auto scaling"
  default     = false
}

variable "max_count" {
  type        = number
  description = "Max node count"
  default     = null
}

variable "min_count" {
  type        = number
  description = "Min node count"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}