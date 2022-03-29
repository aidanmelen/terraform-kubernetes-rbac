output "service_account_name" {
  description = "The service account name."
  value       = kubernetes_service_account_v1.terraform_admin.metadata[0].name
}

output "terraform_admin_auth_token" {
  description = "The service account auth token."
  value       = data.kubernetes_secret.terraform_admin.data.token
  sensitive   = true
}

output "terraform_admin_auth_namespace" {
  description = "The service account auth namespace."
  value       = nonsensitive(data.kubernetes_secret.terraform_admin.data.namespace)
}

output "terraform_admin_auth_ca_crt" {
  description = "The service account auth ca certificate."
  value       = data.kubernetes_secret.terraform_admin.data["ca.crt"]
  sensitive   = true
}

output "terraform_admin_rbac" {
  description = "The service account RBAC."
  value       = module.terraform_admin.cluster_roles
}
