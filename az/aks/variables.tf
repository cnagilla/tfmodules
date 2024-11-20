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

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes cluster version"
}

variable "dns_prefix" {
  type        = string
  description = "Kubernetes cluster version"
}

variable "private_cluster_enabled" {
  type        = bool
  description = "Enabled private cluster endpoint"
  default     = false
}

variable "sku_tier" {
  type        = string
  description = "Kubernetes cluster pricing tier"
  default     = "Free"
  validation {
    condition     = contains(["Paid", "Free", "Standard"], var.sku_tier)
    error_message = "Cluster pricing tier must be one of Free, Standard or Paid."
  }
}

variable "private_dns_zone_id" {
  type        = string
  description = "DNS zone ID for private cluster"
  default     = null
}

variable "key_vault_secrets_provider" {
  type   = any
  description = "Key vault secrets provider configuration"
  default = {}
}

variable "oidc_issuer_enabled" {
  type        = string
  description = "Enable OIDC issuer"
  default     = false
}

variable "enable_rbac" {
  type        = bool
  description = "Enable Role Based Access Control based on Azure AD"
  default     = false
}

variable "node_pool" {
  type        = any
  description = "Default node pool configuration"
}

variable "oms_agent" {
  type        = any
  description = "Cluster logging configuration"
  default     = {}
}

variable "maintenance_window_auto_upgrade" {
  type        = any
  description = "Maintenance Window"
  default     = {}
}
variable "ingress_application_gateway" {
  type        = any
  description = "Application gateway configuration"
  default     = {}
}

variable "network_profile" {
  type        = any
  description = "Network plugin configuration"
  default     = {}
}

variable "linux_profile" {
  type        = any
  description = "SSH access configuration"
  default     = {}
}

variable "identity" {
  type        = any
  description = "Identity configuration"
  default     = {}
}

variable "timeouts" {
  type        = map(number)
  description = "Timeouts"
  default     = {}
}

variable "azure_policy_enabled" {
  type        = bool
  description = "Policy ADDons enabled"
  default     = true
}

variable "api_server_access_profile" {
  type        = any
  description = "Control plane white IP list"
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}