locals {
  name = "ex-${replace(basename(path.cwd), "_", "-")}"
}

module "service_account" {
  source = "../../"
  name   = local.name
}

provider "kubernetes" {
  alias                  = "service_account"
  host                   = "https://kubernetes.docker.internal:6443"
  cluster_ca_certificate = module.service_account.secrets["ca.crt"]
  token                  = module.service_account.secrets["token"]
}
