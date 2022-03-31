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
