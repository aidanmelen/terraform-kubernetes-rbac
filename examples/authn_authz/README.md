<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


# Terraform Admin Example

Create `terraform-admin` kuberenetes service account and pass the auth token to the kubernetes provider.
These service account tokens will not expire and are ideal for deployments that take exceed 15 minutes.

```hcl
locals {
  name = "ex-${replace(basename(path.cwd), "_", "-")}"
}

module "terraform_admin" {
  source = "../../"

  labels = {
    "terraform-example" = local.name
  }

  service_account_name      = "terraform-admin"
  service_account_namespace = "kube-system"

  cluster_roles = {
    "cluster-admin" = {
      create_cluster_role       = false
      cluster_role_binding_name = "terraform-admin-global"
      cluster_role_binding_subjects = [
        {
          kind = "ServiceAccount"
          name = "terraform-admin"
        }
      ]
    }
  }
}

provider "kubernetes" {
  alias                  = "terraform-admin"
  host                   = "https://kubernetes.docker.internal:6443"
  cluster_ca_certificate = module.terraform_admin.service_account_secrets["ca.crt"]
  token                  = module.terraform_admin.service_account_secrets["token"]
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
1. `go test terraform_terraform_admin_test.go -v`

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
| <a name="module_terraform_admin"></a> [terraform\_admin](#module\_terraform\_admin) | ../../ | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_account_name"></a> [service\_account\_name](#output\_service\_account\_name) | The `terraform_admin` service account name. |
| <a name="output_terraform_admin_auth_ca_crt"></a> [terraform\_admin\_auth\_ca\_crt](#output\_terraform\_admin\_auth\_ca\_crt) | The `terraform_admin` service account auth ca certificate. |
| <a name="output_terraform_admin_auth_namespace"></a> [terraform\_admin\_auth\_namespace](#output\_terraform\_admin\_auth\_namespace) | The `terraform_admin` service account auth namespace. |
| <a name="output_terraform_admin_auth_token"></a> [terraform\_admin\_auth\_token](#output\_terraform\_admin\_auth\_token) | The `terraform_admin` service account auth token. |
| <a name="output_terraform_admin_rbac"></a> [terraform\_admin\_rbac](#output\_terraform\_admin\_rbac) | The `terraform_admin` service account RBAC. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
