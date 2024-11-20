variable "name" {
  type        = string
  description = "Resource name"
}

variable "cdn_frontdoor_profile_id" {
  type        = string
  description = "Front Door profile"
}

variable "key_vault_certificate_id" {
  type        = string
  description = "KV certificate ID"
}