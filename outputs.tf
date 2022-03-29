output "roles" {
  description = "The roles."
  value       = try(module.roles, [])
}

output "cluster_roles" {
  description = "The cluster roles."
  value       = try(module.cluster_roles, [])
}
