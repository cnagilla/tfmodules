output "metadata" {
  value       = helm_release.this.metadata
  description = "Release meta"
}

output "status" {
  value       = helm_release.this.status
  description = "Release status"
}