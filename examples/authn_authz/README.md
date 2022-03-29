<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


# Basic Example

Create an kuberenetes service account and pass the auth token to the kubernetes provider.

```hcl
module "service_account" {
  source = "aidanmelen/service-account/kubernetes"
  name   = "basic"
}

provider "kubernetes" {
  alias                  = "service_account"
  host                   = "https://kubernetes.docker.internal:6443"
  cluster_ca_certificate = module.service_account.secrets["ca.crt"]
  token                  = module.service_account.secrets["token"]
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
1. `go test terraform_basic_test.go -v`

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
| <a name="module_service_account"></a> [service\_account](#module\_service\_account) | ../../ | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_account_auth_ca_crt"></a> [service\_account\_auth\_ca\_crt](#output\_service\_account\_auth\_ca\_crt) | THe service account auth ca certificate. |
| <a name="output_service_account_auth_namespace"></a> [service\_account\_auth\_namespace](#output\_service\_account\_auth\_namespace) | THe service account auth namespace. |
| <a name="output_service_account_auth_token"></a> [service\_account\_auth\_token](#output\_service\_account\_auth\_token) | The service account auth token. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
