provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "docker-desktop"
}

# provider "kubernetes" {
#   alias                  = "service_account"
#   host                   = "https://kubernetes.docker.internal:6443"
#   cluster_ca_certificate = module.service_account.secrets["ca.crt"]
#   token                  = module.service_account.secrets["token"]
# }
