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
