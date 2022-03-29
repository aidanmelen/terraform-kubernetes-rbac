[![Pre-Commit](https://github.com/aidanmelen/terraform-kubernetes-rbac/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/aidanmelen/terraform-kubernetes-rbac/actions/workflows/pre-commit.yaml)
[![cookiecutter-tf-module](https://img.shields.io/badge/cookiecutter--tf--module-enabled-brightgreen)](https://github.com/aidanmelen/cookiecutter-tf-module)
[![StandWithUkraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/badges/StandWithUkraine.svg)](https://github.com/vshymanskyy/StandWithUkraine/blob/main/docs/README.md)

# terraform-kubernetes-rbac

A Terraform module for managing [Kubernetes RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## Usage

Recreate the RBAC examples from the [Using RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) on Kubernetes documentation.

```hcl
module "roles" {
  source = "./modules/rbac"

  for_each = { for k, v in var.roles : k => v if var.create }

  create = try(each.value.create, true)

  annotations = try(var.annotations, null)
  labels      = try(var.labels, null)

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

  annotations = try(var.annotations, null)
  labels      = try(var.labels, null)

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
```

Please see the [rbac example](examples/rbac) for more information.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.7.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cluster_roles"></a> [cluster\_roles](#module\_cluster\_roles) | ./modules/rbac | n/a |
| <a name="module_roles"></a> [roles](#module\_roles) | ./modules/rbac | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_annotations"></a> [annotations](#input\_annotations) | The global annotations. Applied to all resources. | `map(string)` | `{}` | no |
| <a name="input_cluster_roles"></a> [cluster\_roles](#input\_cluster\_roles) | The cluster roles to bind to the service account. Set `create_cluster_role = false` to use pre-existing cluster role. | `any` | `{}` | no |
| <a name="input_create"></a> [create](#input\_create) | Controls whether the Authorization and RBAC resources should be created (affects all resources). | `bool` | `true` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | The global labels. Applied to all resources. | `map(string)` | `{}` | no |
| <a name="input_roles"></a> [roles](#input\_roles) | The roles to bind to the service account. Set `create_role = false` to use pre-existing role. | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_roles"></a> [cluster\_roles](#output\_cluster\_roles) | The cluster roles. |
| <a name="output_roles"></a> [roles](#output\_roles) | The roles. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache 2 Licensed. See [LICENSE](https://github.com/aidanmelen/terraform-aws-eks-auth/tree/master/LICENSE) for full details.
