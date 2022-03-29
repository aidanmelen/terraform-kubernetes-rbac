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
