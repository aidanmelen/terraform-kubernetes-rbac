output "service_account_name" {
    value = try(kubernetes_service_account_v1.sa[0].metadata[0].name, null)
}

output "service_account_secrets" {
    value = try(data.kubernetes_secret.service_account[0].data, null)
}

output "roles" {
    value = try(module.roles, [])
}

output "cluster_roles" {
    value = try(module.cluster_roles, [])
}