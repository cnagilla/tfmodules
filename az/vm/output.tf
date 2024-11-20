output "id" {
  value       = var.os_family == "windows" ? azurerm_windows_virtual_machine.this[0].id : azurerm_linux_virtual_machine.this[0].id
  description = "ID"
}

output "name" {
  value       = var.os_family == "windows" ? azurerm_windows_virtual_machine.this[0].name : azurerm_linux_virtual_machine.this[0].name
  description = "Name"
}

output "private_ip_address" {
  value       = var.os_family == "windows" ? azurerm_windows_virtual_machine.this[0].private_ip_address : azurerm_linux_virtual_machine.this[0].private_ip_address
  description = "Primary private IP address"
}

output "private_ip_addresses" {
  value       = var.os_family == "windows" ? azurerm_windows_virtual_machine.this[0].private_ip_addresses : azurerm_linux_virtual_machine.this[0].private_ip_addresses
  description = "All private IP addresses"
}

output "public_ip_address" {
  value       = var.os_family == "windows" ? azurerm_windows_virtual_machine.this[0].public_ip_address : azurerm_linux_virtual_machine.this[0].public_ip_address
  description = "Primary public IP address"
}

output "public_ip_addresses" {
  value       = var.os_family == "windows" ? azurerm_windows_virtual_machine.this[0].public_ip_addresses : azurerm_linux_virtual_machine.this[0].public_ip_addresses
  description = "All public IP addresses"
}