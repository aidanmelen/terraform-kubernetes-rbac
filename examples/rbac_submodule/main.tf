locals {
  labels = {
    "terraform-example"            = "ex-${replace(basename(path.cwd), "_", "-")}"
    "app.kubernetes.io/managed-by" = "Terraform"
    "terraform.io/module"          = "terraform-kubernetes-rbac"
  }
}

# https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-example
# https://kubernetes.io/docs/reference/access-authn-authz/rbac/#rolebinding-example
module "pod_reader" {
  # source = "aidan-melen/rbac/kubernetes//modules/rbac"
  source = "../../modules/rbac"

  create = true
  labels = local.labels

  role_name      = "pod-reader"
  role_namespace = "default"
  role_rules = [
    {
      api_groups = [""]
      resources  = ["pods"]
      verbs      = ["get", "watch", "list"]
    },
  ]

  # This role binding allows "jane" to read pods in the "default" namespace.
  # You need to already have a Role named "pod-reader" in that namespace.
  role_binding_name = "read-pods"
  role_binding_subjects = [
    {
      kind     = "User"
      name     = "jane" # Name is case sensitive
      apiGroup = "rbac.authorization.k8s.io"
    }
  ]
}

# https://kubernetes.io/docs/reference/access-authn-authz/rbac/#clusterrole-example
# https://kubernetes.io/docs/reference/access-authn-authz/rbac/#rolebinding-example
module "secret_reader" {
  # source = "aidan-melen/rbac/kubernetes//modules/rbac"
  source = "../../modules/rbac"

  create = true
  labels = local.labels

  # at the HTTP level, the name of the resource for accessing Secret
  # objects is "secrets"
  cluster_role_name = "secret-reader"
  # "namespace" omitted since ClusterRoles are not namespaced
  cluster_role_rules = [
    {
      api_groups = [""]
      resources  = ["secrets"]
      verbs      = ["get", "watch", "list"]
    },
  ]

  role_binding_name = "read-secret"
  # The namespace of the RoleBinding determines where the permissions are granted.
  # This only grants permissions within the "development" namespace.
  role_binding_namespace = kubernetes_namespace.development.metadata[0].name
  role_binding_subjects = [
    {
      kind     = "User"
      name     = "dave" # Name is case sensitive
      apiGroup = "rbac.authorization.k8s.io"
    }
  ]
}

resource "kubernetes_namespace" "development" {
  metadata {
    name   = "development"
    labels = local.labels
  }
}

# https://kubernetes.io/docs/reference/access-authn-authz/rbac/#clusterrole-example
# https://kubernetes.io/docs/reference/access-authn-authz/rbac/#clusterrolebinding-example
module "secret_reader_global" {
  # source = "aidan-melen/rbac/kubernetes//modules/rbac"
  source = "../../modules/rbac"

  create = true
  labels = local.labels

  cluster_role_name = "secret-reader-global"
  # "namespace" omitted since ClusterRoles are not namespaced
  cluster_role_rules = [
    {
      api_groups = [""]
      resources  = ["secrets"]
      verbs      = ["get", "watch", "list"]
    },
  ]

  # This cluster role binding allows anyone in the "manager" group to read secrets in any namespace.
  cluster_role_binding_name = "read-secrets-global"
  cluster_role_binding_subjects = [
    {
      kind     = "Group"
      name     = "manager" # Name is case sensitive
      apiGroup = "rbac.authorization.k8s.io"
    }
  ]
}

module "terraform_admin_global" {
  # source = "aidan-melen/rbac/kubernetes//modules/rbac"
  source = "../../modules/rbac"

  create = true
  labels = local.labels

  create_cluster_role = false
  cluster_role_name   = "cluster-admin"

  cluster_role_binding_name = "terraform-admin-global"
  cluster_role_binding_subjects = [
    {
      kind     = "Group"
      name     = "terraform-admin" # Name is case sensitive
      apiGroup = "rbac.authorization.k8s.io"
    }
  ]
}
