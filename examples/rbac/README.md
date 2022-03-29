<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


# RBAC Example

Recreate the RBAC examples from the [Using RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) on Kubernetes documentation.

```hcl
locals {
  labels = {
    "terraform-example"            = "ex-${replace(basename(path.cwd), "_", "-")}"
    "app.kubernetes.io/managed-by" = "Terraform"
    "terraform.io/module"          = "terraform-kubernetes-rbac"
  }
}

resource "kubernetes_namespace" "development" {
  metadata {
    name   = "development"
    labels = local.labels
  }
}

module "rbac" {
  source = "../../"

  labels = local.labels

  roles = {
    # https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-example
    # https://kubernetes.io/docs/reference/access-authn-authz/rbac/#rolebinding-example
    "pod-reader" = {
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
    },
  }

  cluster_roles = {
    # https://kubernetes.io/docs/reference/access-authn-authz/rbac/#clusterrole-example
    # https://kubernetes.io/docs/reference/access-authn-authz/rbac/#rolebinding-example
    "secret-reader" = {
      # at the HTTP level, the name of the resource for accessing Secret
      # objects is "secrets"
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
    },

    # https://kubernetes.io/docs/reference/access-authn-authz/rbac/#clusterrole-example
    # https://kubernetes.io/docs/reference/access-authn-authz/rbac/#clusterrolebinding-example
    "secret-reader-global" = {
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
  }
}

module "pre_existing" {
  source = "../../"

  cluster_roles = {
    "cluster-admin" = {
      create_cluster_role       = false
      cluster_role_binding_name = "cluster-admin-global"
      cluster_role_binding_subjects = [
        {
          kind = "User"
          name = "bob"
        }
      ]
    }
  }
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
1. `go test terraform_rbac_test.go -v`

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
| <a name="module_pre_existing"></a> [pre\_existing](#module\_pre\_existing) | ../../ | n/a |
| <a name="module_rbac"></a> [rbac](#module\_rbac) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [kubernetes_namespace.development](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_pre_existing"></a> [pre\_existing](#output\_pre\_existing) | The pre-existing roles, cluster roles, role bindings and cluster role bindings. |
| <a name="output_rbac"></a> [rbac](#output\_rbac) | The roles, cluster roles, role bindings and cluster role bindings. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
