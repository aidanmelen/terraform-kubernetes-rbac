output "service_account_auth_token" {
  description = "The service account auth token."
  value       = module.service_account.secrets.token
  sensitive   = true
}

output "service_account_auth_namespace" {
  description = "THe service account auth namespace."
  value       = nonsensitive(module.service_account.secrets.namespace)
}

output "service_account_auth_ca_crt" {
  description = "THe service account auth ca certificate."
  value       = module.service_account.secrets["ca.crt"]
  sensitive   = true
}
