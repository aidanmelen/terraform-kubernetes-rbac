output "role_name" {
  description = "The role name."
  value       = var.create && var.namespace != null ? kubernetes_role_v1.r[0].metadata[0].name : null
}

output "role_namespace" {
  description = "The namespace in which the role belongs."
  value       = var.create && var.namespace != null ? kubernetes_role_v1.r[0].metadata[0].name : null
}

output "role_binding_name" {
  description = "The role binding name."
  value       = var.create && var.namespace != null ? kubernetes_role_binding_v1.rb[0].metadata[0].name : null
}

output "role_binding_namespace" {
  description = "The namespace in which the role binding belongs."
  value       = var.create && var.binding_namespace != null ? kubernetes_role_binding_v1.rb[0].metadata[0].namespace : null
}

output "cluster_role_name" {
  description = ""
  value       = var.create && var.namespace == null ? kubernetes_cluster_role_v1.cr[0].metadata[0].name : null
}

output "cluster_role_binding_name" {
  description = ""
  value       = var.create && var.binding_namespace == null ? kubernetes_cluster_role_binding_v1.crb[0].metadata[0].name : null
}
