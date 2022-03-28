<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


# Basic Example

Create a service account annotated with AWS IAM role bond with kubernetes `view` role.

```hcl
locals {
  name = "ex-${replace(basename(path.cwd), "_", "-")}"
}

module "pod_service_account" {
  source = "../../"
  name   = local.name

  annotations = {
    "eks.amazonaws.com/role-arn" = aws_iam_role.s3_readonly.arn
  }

  cluster_role_name = "view"
  create_role       = false
}

resource "kubernetes_job_v1" "job" {
  metadata {
    name      = local.name
    namespace = "kube-system"
  }

  spec {
    template {
      metadata {}
      spec {
        service_account_name = module.pod_service_account.service_account_name

        # use the iam role
        container {
          name    = local.name
          image   = "amazonlinux:latest"
          command = ["/bin/bash", "-c", "aws s3 ls"]
        }

        # use the k8s role
        container {
          name    = local.name
          image   = "bitnami/kubectl:latest"
          command = ["/bin/sh", "-c", "kubectl get namespaces"]
        }

        restart_policy = "Never"
      }
    }
  }

  wait_for_completion = true

  timeouts {
    create = "10m"
    update = "10m"
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
1. `go test terraform_basic_test.go -v`

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.72 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.72 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.7.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | >= 18.0.0 |
| <a name="module_pod_service_account"></a> [pod\_service\_account](#module\_pod\_service\_account) | ../../ | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.s3_readonly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [kubernetes_job_v1.job](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/job_v1) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_policy_document.trust](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS Region | `string` | `"us-west-2"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
