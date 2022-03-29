output "service_account_name" {
  description = "The service account name."
  value       = try(kubernetes_service_account_v1.sa[0].metadata[0].name, null)
}

output "service_account_secrets" {
  description = "The service account secret authentication data."
  value       = try(data.kubernetes_secret.service_account[0].data, null)
}

output "roles" {
  description = "The roles."
  value       = try(module.roles, [])
}

output "cluster_roles" {
  description = "The cluster roles."
  value       = try(module.cluster_roles, [])
}
