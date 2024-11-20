variable "firewall_name" {
  type        = string
  description = "Firewall name"
}

variable "public_ip_name" {
  type        = string
  description = "Firewall public IP name"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "vnet_name" {
  type        = string
  description = "Vnet with AzureFirewallSubnet subnet"
  default     = ""
}

variable "subscription" {
  type        = string
  description = "Azure subscription"
}