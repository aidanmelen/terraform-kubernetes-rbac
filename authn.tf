locals {
  merged_labels = merge(
    {
      "app.kubernetes.io/managed-by" = "Terraform"
      "terraform.io/module"          = "terraform-kubernetes-service-account"
    },
    var.labels
  )
}

data "kubernetes_secret" "service_account" {
  count = var.create_service_account && var.service_account_name != null ? 1 : 0

  metadata {
    name      = kubernetes_service_account_v1.sa[0].default_secret_name
    namespace = var.service_account_namespace
  }
}

resource "kubernetes_service_account_v1" "sa" {
  count = var.create_service_account && var.service_account_name != null ? 1 : 0

  metadata {
    name        = var.service_account_name
    namespace   = var.service_account_namespace
    annotations = var.annotations
    labels      = local.merged_labels
  }
}
