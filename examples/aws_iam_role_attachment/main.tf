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
