# https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-example
# https://kubernetes.io/docs/reference/access-authn-authz/rbac/#rolebinding-example
module "pod_reader" {
  source = "../../modules/authorization"

  create = true

  # This role binding allows "jane" to read pods in the "default" namespace.
  # You need to already have a Role named "pod-reader" in that namespace.
  name      = "pod-reader"
  namespace = "default"
  rules = [
    {
      api_groups = [""]
      resources  = ["pods"]
      verbs      = ["get", "watch", "list"]
    },
  ]

  binding_name = "read-pods"
  binding_subjects = [
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
  source = "../../modules/authorization"

  create = false

  # at the HTTP level, the name of the resource for accessing Secret
  # objects is "secrets"
  name = "secret-reader"
  # "namespace" omitted since ClusterRoles are not namespaced
  rules = [
    {
      api_groups = [""]
      resources  = ["secrets"]
      verbs      = ["get", "watch", "list"]
    },
  ]

  binding_name = "read-secret"
  # The namespace of the RoleBinding determines where the permissions are granted.
  # This only grants permissions within the "development" namespace.
  binding_namespace = kubernetes_namespace.development.metadata[0].name
  binding_subjects = [
    {
      kind     = "User"
      name     = "dave" # Name is case sensitive
      apiGroup = "rbac.authorization.k8s.io"
    }
  ]
}

resource "kubernetes_namespace" "development" {
  metadata {
    name = "development"
  }
}

# https://kubernetes.io/docs/reference/access-authn-authz/rbac/#clusterrole-example
# https://kubernetes.io/docs/reference/access-authn-authz/rbac/#clusterrolebinding-example
module "secret_reader_global" {
  source = "../../modules/authorization"

  create = false
  name = "secret-reader-global"
  # "namespace" omitted since ClusterRoles are not namespaced
  rules = [
    {
      api_groups = [""]
      resources  = ["secrets"]
      verbs      = ["get", "watch", "list"]
    },
  ]

  # This cluster role binding allows anyone in the "manager" group to read secrets in any namespace.
  binding_name = "read-secrets-global"
  binding_subjects = [
    {
      kind     = "Group"
      name     = "manager" # Name is case sensitive
      apiGroup = "rbac.authorization.k8s.io"
    }
  ]
}
