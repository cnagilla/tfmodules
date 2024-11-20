output "name" {
  value       = azurerm_cdn_frontdoor_rule_set.this.name
  description = "Rule set name"
}

output "id" {
  value       = azurerm_cdn_frontdoor_rule_set.this.id
  description = "Rules set ID"
}