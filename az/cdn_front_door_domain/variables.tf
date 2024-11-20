variable "name" {
  type        = string
  description = "Resource name"
}

variable "cdn_frontdoor_profile_id" {
  type        = string
  description = "Front Door profile"
}

variable "dns_zone_id" {
  type        = string
  description = "Azure DNS zone ID"
  default     = null
}

variable "host_name" {
  type        = string
  description = "FQDN"
}

variable "certificate_type" {
  type        = string
  description = "TLS certificate source type"
  validation {
    condition     = contains(["CustomerCertificate", "ManagedCertificate"], var.certificate_type)
    error_message = "Certificate type should be one of ManagedCertificate or CustomerCertificate."
  }
}

variable "minimum_tls_version" {
  type        = string
  description = "TLS version"
  default     = "TLS12"
}

variable "cdn_frontdoor_secret_id" {
  type        = string
  description = "KV secret ID of CustomerCertificate"
  default     = null
}