output "rbac" {
  description = "The roles, cluster roles, role bindings and cluster role bindings."
  value       = module.rbac
}

output "pre_existing" {
  description = "The pre-existing roles, cluster roles, role bindings and cluster role bindings."
  value       = module.pre_existing
}
