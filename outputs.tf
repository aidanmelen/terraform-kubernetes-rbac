# output "service_account_name" {
#   description = "The service account name."
#   value       = kubernetes_service_account_v1.sa.metadata[0].name
# }

# output "secrets" {
#   description = "The service account secret authorization data."
#   value       = sensitive(data.kubernetes_secret.service_account.data)
#   sensitive   = true
# }

# output "role_names" {
#   description = "The role names."
#   value       = [for r in kubernetes_role_v1.r : r.metadata[0].name]
# }

# output "role_binding_names" {
#   description = "The role binding names."
#   value = concat(
#     [for rb in kubernetes_role_binding_v1.rb : rb.metadata[0].name],
#     [for cr_rb in kubernetes_role_binding_v1.cr_rb : cr_rb.metadata[0].name]
#   )
# }

# output "cluster_role_names" {
#   description = "The cluster role names."
#   value       = [for cr in kubernetes_cluster_role_v1.cr : cr.metadata[0].name]
# }

# output "cluster_role_binding_names" {
#   description = "The cluster role binding names."
#   value       = [for crb in kubernetes_cluster_role_binding_v1.crb : crb.metadata[0].name]
# }

output "test" {
  value = var.roles
}
