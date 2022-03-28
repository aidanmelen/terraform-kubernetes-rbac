locals {
  merged_labels = merge(
    {
      "app.kubernetes.io/managed-by" = "Terraform"
      "terraform.io/module"          = "terraform-kubernetes-service-account"
    },
    var.additional_labels
  )
}

data "kubernetes_secret" "service_account" {
  metadata {
    name      = kubernetes_service_account_v1.sa.default_secret_name
    namespace = var.namespace
  }
}

resource "kubernetes_service_account_v1" "sa" {
  metadata {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations
    labels      = local.merged_labels
  }
}
