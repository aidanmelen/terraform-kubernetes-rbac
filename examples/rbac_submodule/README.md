<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


# RBAC Sub-module Example

Create RBAC resources using the sub-module directly.

```hcl
locals {
  labels = {
    "terraform-example"            = "ex-${replace(basename(path.cwd), "_", "-")}"
    "app.kubernetes.io/managed-by" = "Terraform"
    "terraform.io/module"          = "terraform-kubernetes-rbac"
  }
}

# https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-example
# https://kubernetes.io/docs/reference/access-authn-authz/rbac/#rolebinding-example
module "pod_reader" {
  source = "../../modules/rbac"

  create = true
  labels = local.labels

  role_name      = "pod-reader"
  role_namespace = "default"
  role_rules = [
    {
      api_groups = [""]
      resources  = ["pods"]
      verbs      = ["get", "watch", "list"]
    },
  ]

  # This role binding allows "jane" to read pods in the "default" namespace.
  # You need to already have a Role named "pod-reader" in that namespace.
  role_binding_name = "read-pods"
  role_binding_subjects = [
    {
      kind     = "User"
      name     = "jane" # Name is case sensitive
      apiGroup = "rbac.authorization.k8s.io"
    }
  ]
}

# https://kubernetes.io/docs/reference/access-authn-authz/rbac/#clusterrole-example
# https://kubernetes.io/docs/reference/access-authn-authz/rbac/#rolebinding-example
module "secret_reader" {
  source = "../../modules/rbac"

  create = true
  labels = local.labels

  # at the HTTP level, the name of the resource for accessing Secret
  # objects is "secrets"
  cluster_role_name = "secret-reader"
  # "namespace" omitted since ClusterRoles are not namespaced
  cluster_role_rules = [
    {
      api_groups = [""]
      resources  = ["secrets"]
      verbs      = ["get", "watch", "list"]
    },
  ]

  role_binding_name = "read-secret"
  # The namespace of the RoleBinding determines where the permissions are granted.
  # This only grants permissions within the "development" namespace.
  role_binding_namespace = kubernetes_namespace.development.metadata[0].name
  role_binding_subjects = [
    {
      kind     = "User"
      name     = "dave" # Name is case sensitive
      apiGroup = "rbac.authorization.k8s.io"
    }
  ]
}

resource "kubernetes_namespace" "development" {
  metadata {
    name   = "development"
    labels = local.labels
  }
}

# https://kubernetes.io/docs/reference/access-authn-authz/rbac/#clusterrole-example
# https://kubernetes.io/docs/reference/access-authn-authz/rbac/#clusterrolebinding-example
module "secret_reader_global" {
  source = "../../modules/rbac"

  create = true
  labels = local.labels

  cluster_role_name = "secret-reader-global"
  # "namespace" omitted since ClusterRoles are not namespaced
  cluster_role_rules = [
    {
      api_groups = [""]
      resources  = ["secrets"]
      verbs      = ["get", "watch", "list"]
    },
  ]

  # This cluster role binding allows anyone in the "manager" group to read secrets in any namespace.
  cluster_role_binding_name = "read-secrets-global"
  cluster_role_binding_subjects = [
    {
      kind     = "Group"
      name     = "manager" # Name is case sensitive
      apiGroup = "rbac.authorization.k8s.io"
    }
  ]
}

module "terraform_admin_global" {
  source = "../../modules/rbac"

  create = true
  labels = local.labels

  create_cluster_role = false
  cluster_role_name   = "cluster-admin"

  cluster_role_binding_name = "terraform-admin-global"
  cluster_role_binding_subjects = [
    {
      kind     = "Group"
      name     = "terraform-admin" # Name is case sensitive
      apiGroup = "rbac.authorization.k8s.io"
    }
  ]
}
```

## Running this module manually

1. Install [Terraform](https://www.terraform.io/) and make sure it's on your `PATH`.
1. Run `terraform init`.
1. Run `terraform apply`.
1. When you're done, run `terraform destroy`.

## Running automated tests against this module

1. Install [Terraform](https://www.terraform.io/) and make sure it's on your `PATH`.
1. Install [Golang](https://golang.org/) and make sure this code is checked out into your `GOPATH`.
1. `cd test`
1. `go test terraform_rbac_submodule_test.go -v`

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.7.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_pod_reader"></a> [pod\_reader](#module\_pod\_reader) | ../../modules/rbac | n/a |
| <a name="module_secret_reader"></a> [secret\_reader](#module\_secret\_reader) | ../../modules/rbac | n/a |
| <a name="module_secret_reader_global"></a> [secret\_reader\_global](#module\_secret\_reader\_global) | ../../modules/rbac | n/a |
| <a name="module_terraform_admin_global"></a> [terraform\_admin\_global](#module\_terraform\_admin\_global) | ../../modules/rbac | n/a |

## Resources

| Name | Type |
|------|------|
| [kubernetes_namespace.development](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_pod_reader"></a> [pod\_reader](#output\_pod\_reader) | pod\_reader |
| <a name="output_secret_reader"></a> [secret\_reader](#output\_secret\_reader) | secret\_reader |
| <a name="output_secret_reader_global"></a> [secret\_reader\_global](#output\_secret\_reader\_global) | secret\_reader\_global |
| <a name="output_terraform_admin_global"></a> [terraform\_admin\_global](#output\_terraform\_admin\_global) | terraform\_admin\_global |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
