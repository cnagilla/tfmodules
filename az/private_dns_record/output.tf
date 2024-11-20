output "a_records" {
  value       = azurerm_private_dns_a_record.this
  description = "DNS A Records"
}

output "cname_records" {
  value       = azurerm_private_dns_cname_record.this
  description = "DNS CNAME Records"
}