output "service_account_name" {
  description = "The `terraform_admin` service account name."
  value = module.terraform_admin.service_account_name
}

output "terraform_admin_auth_token" {
  description = "The `terraform_admin` service account auth token."
  value       = module.terraform_admin.service_account_secrets.token
  sensitive   = true
}

output "terraform_admin_auth_namespace" {
  description = "The `terraform_admin` service account auth namespace."
  value       = nonsensitive(module.terraform_admin.service_account_secrets.namespace)
}

output "terraform_admin_auth_ca_crt" {
  description = "The `terraform_admin` service account auth ca certificate."
  value       = module.terraform_admin.service_account_secrets["ca.crt"]
  sensitive   = true
}

output "terraform_admin_rbac" {
  value = module.terraform_admin.cluster_roles
}