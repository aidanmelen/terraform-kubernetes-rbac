output "role_name" {
  description = "The role name."
  value = (
    var.create && var.role_name != null ?
    (var.create_role == true ? kubernetes_role_v1.r[0].metadata[0].name : local.role_name) :
    null
  )
}

output "role_namespace" {
  description = "The namespace in which the role belongs."
  value = (
    var.create && var.role_namespace != null ? var.role_namespace :
    null
  )
}

output "role_binding_name" {
  description = "The role binding name."
  value = (
    var.create && var.role_binding_subjects != null ?
    kubernetes_role_binding_v1.rb[0].metadata[0].name :
    null
  )
}

output "role_binding_namespace" {
  description = "The namespace in which the role binding belongs."
  value = (
    var.create && var.role_binding_namespace != null ?
    kubernetes_role_binding_v1.rb[0].metadata[0].namespace :
    try(kubernetes_role_v1.r[0].metadata[0].namespace, null)
  )
}

output "cluster_role_name" {
  description = "The cluster role name."
  value = (
    var.create && var.cluster_role_name != null ?
    (var.create_cluster_role == true ? kubernetes_cluster_role_v1.cr[0].metadata[0].name : local.cluster_role_name) :
    null
  )
}

output "cluster_role_binding_name" {
  description = "The cluster role binding name."
  value = (
    var.create && var.cluster_role_binding_subjects != null ?
    kubernetes_cluster_role_binding_v1.crb[0].metadata[0].name :
    null
  )
}
