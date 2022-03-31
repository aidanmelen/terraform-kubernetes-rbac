# output "rbac" {
#   description = "The roles, cluster roles, role bindings and cluster role bindings."
#   value       = module.rbac
# }

# output "pre_existing" {
#   description = "The pre-existing roles, cluster roles, role bindings and cluster role bindings."
#   value       = module.pre_existing
# }

output "pod_reader" {
  description = "The `pod-reader` role."
  value       = module.rbac.roles["pod-reader"]
}

output "secret_reader" {
  description = "The `secret-reader` cluster role."
  value       = module.rbac.cluster_roles["secret-reader"]
}

output "secret_reader_global" {
  description = "The `secret-reader-global` cluster role."
  value       = module.rbac.cluster_roles["secret-reader-global"]
}

output "cluster_admin" {
  description = "The `cluster-admin` pre-existing cluster role."
  value       = module.pre_existing.cluster_roles["cluster-admin"]
}
