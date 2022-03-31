<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


# Basic Example

Create a Kubernetes service account with AWS S3 list and Kubernetes namespace get privileges. Then grant a pod these privileges by attaching the service account.

```hcl
locals {
  name = "ex-${replace(basename(path.cwd), "_", "-")}"
  labels = {
    "terraform-example"            = local.name
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


resource "kubernetes_service_account_v1" "my_service_account" {
  metadata {
    name      = "my-service-account"
    namespace = kubernetes_namespace.development.metadata[0].name
    labels    = local.labels
  }
}

module "rbac" {
  # source = "aidan-melen/rbac/kubernetes"
  source = "../../"

  annotations = {
    "eks.amazonaws.com/role-arn" = aws_iam_role.s3_readonly.arn
  }

  cluster_roles = {
    "view" = {
      create_cluster_role = false
      cluster_role_binding_subjects = [
        {
          kind = "ServiceAccount"
          name = kubernetes_service_account_v1.my_service_account.metadata[0].name
        }
      ]
    }
  }
}

resource "kubernetes_job_v1" "job" {
  metadata {
    name      = local.name
    namespace = kubernetes_namespace.development.metadata[0].name
  }

  spec {
    template {
      metadata {
        labels = local.labels
      }
      spec {
        service_account_name = kubernetes_service_account_v1.my_service_account.metadata[0].name

        # use the aws iam role to list aws s3 buckets
        container {
          name    = "aws-s3-ls"
          image   = "amazonlinux:latest"
          command = ["/bin/bash", "-c", "aws s3 ls"]
        }

        # use the k8s cluster role to list k8s namespaces
        container {
          name    = "kubectl-get-ns"
          image   = "bitnami/kubectl:latest"
          command = ["/bin/sh", "-c", "kubectl get namespaces"]
        }

        restart_policy = "Never"
      }
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
1. `go test terraform_aws_iam_role_attachment_test.go -v`

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
| <a name="module_rbac"></a> [rbac](#module\_rbac) | ../../ | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.s3_readonly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [kubernetes_job_v1.job](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/job_v1) | resource |
| [kubernetes_namespace.development](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_service_account_v1.my_service_account](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account_v1) | resource |
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
