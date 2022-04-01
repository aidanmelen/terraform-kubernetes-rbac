<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


# Authn Authz Example

Create a Kubernetes service account named `terraform-admin` and pass the secret auth token to the [terraform-kubernetes-provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs).
Service account tokens do not expire and are ideal for terraform deployments that exceed 15 minutes.

```hcl
locals {
  labels = {
    "terraform-example"            = "ex-${replace(basename(path.cwd), "_", "-")}"
    "app.kubernetes.io/managed-by" = "Terraform"
    "terraform.io/module"          = "terraform-kubernetes-rbac"
  }
}

resource "kubernetes_service_account_v1" "terraform_admin" {
  metadata {
    name      = "terraform-admin"
    namespace = "kube-system"
    labels    = local.labels
  }
}

module "terraform_admin" {
  # source = "aidan-melen/rbac/kubernetes"
  source = "../../"

  labels = local.labels

  cluster_roles = {
    "cluster-admin" = {
      create_cluster_role       = false
      cluster_role_binding_name = "terraform-admin-global"
      cluster_role_binding_subjects = [
        {
          kind = "ServiceAccount"
          name = kubernetes_service_account_v1.terraform_admin.metadata[0].name
        }
      ]
    }
  }
}

data "kubernetes_secret" "terraform_admin" {
  metadata {
    name      = kubernetes_service_account_v1.terraform_admin.metadata[0].name
    namespace = kubernetes_service_account_v1.terraform_admin.metadata[0].namespace
  }
}

provider "kubernetes" {
  alias                  = "terraform-admin"
  host                   = "https://kubernetes.docker.internal:6443"
  cluster_ca_certificate = data.kubernetes_secret.terraform_admin.data["ca.crt"]
  token                  = data.kubernetes_secret.terraform_admin.data["token"]
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
1. `go test terraform_authn_authz_test.go -v`

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
| <a name="module_terraform_admin"></a> [terraform\_admin](#module\_terraform\_admin) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [kubernetes_service_account_v1.terraform_admin](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account_v1) | resource |
| [kubernetes_secret.terraform_admin](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/secret) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_account_name"></a> [service\_account\_name](#output\_service\_account\_name) | The service account name. |
| <a name="output_terraform_admin_auth_ca_crt"></a> [terraform\_admin\_auth\_ca\_crt](#output\_terraform\_admin\_auth\_ca\_crt) | The service account auth ca certificate. |
| <a name="output_terraform_admin_auth_namespace"></a> [terraform\_admin\_auth\_namespace](#output\_terraform\_admin\_auth\_namespace) | The service account auth namespace. |
| <a name="output_terraform_admin_auth_token"></a> [terraform\_admin\_auth\_token](#output\_terraform\_admin\_auth\_token) | The service account auth token. |
| <a name="output_terraform_admin_rbac"></a> [terraform\_admin\_rbac](#output\_terraform\_admin\_rbac) | The service account RBAC. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
