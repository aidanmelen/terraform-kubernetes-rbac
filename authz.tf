module "roles" {
  source = "./modules/rbac"

  for_each = { for k, v in var.roles : k => v if var.create }

  create = try(each.value.create, true)

  create_role    = try(each.value.create_role, true)
  role_name      = each.key
  role_namespace = try(each.value.role_namespace, null)
  role_rules     = try(each.value.role_rules, [])

  role_binding_name      = try(each.value.role_binding_name, null)
  role_binding_namespace = try(each.value.role_binding_namespace, null)
  role_binding_subjects  = try(each.value.role_binding_subjects, null)
}

module "cluster_roles" {
  source = "./modules/rbac"

  for_each = { for k, v in var.cluster_roles : k => v if var.create }

  create = try(each.value.create, true)

  create_cluster_role = try(each.value.create_cluster_role, true)
  cluster_role_name   = each.key
  cluster_role_rules  = try(each.value.cluster_role_rules, [])

  cluster_role_binding_name     = try(each.value.cluster_role_binding_name, null)
  cluster_role_binding_subjects = try(each.value.cluster_role_binding_subjects, null)

  # Ignored when cluster_role_binding_name is provided
  role_binding_name      = try(each.value.role_binding_name, null)
  role_binding_namespace = try(each.value.role_binding_namespace, null)
  role_binding_subjects  = try(each.value.role_binding_subjects, null)
}
