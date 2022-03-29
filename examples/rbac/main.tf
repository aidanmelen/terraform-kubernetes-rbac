locals {
  labels = {
    "terraform-example"            = "ex-${replace(basename(path.cwd), "_", "-")}"
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

module "rbac" {
  source = "../../"

  labels = local.labels

  roles = {
    # https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-example
    # https://kubernetes.io/docs/reference/access-authn-authz/rbac/#rolebinding-example
    "pod-reader" = {
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
    },
  }

  cluster_roles = {
    # https://kubernetes.io/docs/reference/access-authn-authz/rbac/#clusterrole-example
    # https://kubernetes.io/docs/reference/access-authn-authz/rbac/#rolebinding-example
    "secret-reader" = {
      # at the HTTP level, the name of the resource for accessing Secret
      # objects is "secrets"
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
    },

    # https://kubernetes.io/docs/reference/access-authn-authz/rbac/#clusterrole-example
    # https://kubernetes.io/docs/reference/access-authn-authz/rbac/#clusterrolebinding-example
    "secret-reader-global" = {
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
  }
}

module "pre_existing" {
  source = "../../"

  cluster_roles = {
    "cluster-admin" = {
      create_cluster_role       = false
      cluster_role_binding_name = "cluster-admin-global"
      cluster_role_binding_subjects = [
        {
          kind = "User"
          name = "bob"
        }
      ]
    }
  }
}
