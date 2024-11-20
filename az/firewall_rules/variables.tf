variable "firewall_policy_id" {
  type        = string
  description = "Firewall policy ID"
}

variable "firewall_rule_collections" {
  type        = any
  description = "Firewall policy rule collection groups"
}