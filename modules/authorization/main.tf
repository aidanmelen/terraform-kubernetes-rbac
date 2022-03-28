################################################################################
# Role
# https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-example
################################################################################
resource "kubernetes_role_v1" "r" {
  count = var.create && var.create_role && var.namespace != null ? 1 : 0

  metadata {
    annotations   = var.annotations
    # generate_name = var.generate_name
    labels        = var.labels
    name          = var.name
    namespace     = var.namespace
  }

  dynamic "rule" {
    for_each = var.rules

    content {
      api_groups     = lookup(rule.value, "api_groups", null)
      resources      = lookup(rule.value, "resources", null)
      resource_names = lookup(rule.value, "resource_names", null)
      verbs          = lookup(rule.value, "verbs", null)
    }
  }
}

################################################################################
# Cluster Role
# https://kubernetes.io/docs/reference/access-authn-authz/rbac/#clusterrole-example
################################################################################
resource "kubernetes_cluster_role_v1" "cr" {
  count = var.create && var.create_role && var.namespace == null ? 1 : 0

  metadata {
    annotations   = var.annotations
    # generate_name = var.generate_name
    labels        = var.labels
    name          = var.name
  }

  dynamic "rule" {
    for_each = var.rules

    content {
      api_groups        = lookup(rule.value, "api_groups", null)
      resources         = lookup(rule.value, "resources", null)
      non_resource_urls = lookup(rule.value, "non_resource_urls", null)
      resource_names    = lookup(rule.value, "resource_names", null)
      verbs             = lookup(rule.value, "verbs", null)
    }
  }

  dynamic "aggregation_rule" {
    for_each = var.aggregation_rules

    content {
      dynamic "cluster_role_selectors" {
        for_each = lookup(aggregation_rule.value, "cluster_role_selectors", [])

        content {

          match_labels = lookup(cluster_role_selectors.value, "match_labels", {})

          dynamic "match_expressions" {
            for_each = lookup(aggregation_rule.value, "match_expressions", [])

            content {
              key      = lookup(match_expressions.value, "key", null)
              operator = lookup(match_expressions.value, "operator", null)
              values   = lookup(match_expressions.value, "values", null)
            }
          }
        }
      }
    }
  }
}

################################################################################
# Role Bindings
# https://kubernetes.io/docs/reference/access-authn-authz/rbac/#rolebinding-example
################################################################################
resource "kubernetes_role_binding_v1" "rb" {
  count = var.create && var.binding_namespace != null ? 1 : 0

  metadata {
    annotations = var.annotations
    # generate_name = var.generate_name
    labels      = var.labels
    name        = var.binding_name != null ? var.binding_name : var.name
    namespace   = var.binding_namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = var.namespace != null ? "Role" : "ClusterRole"
    name = (
      var.namespace != null ?
      var.create ? kubernetes_role_v1.r[0].metadata[0].name : var.name :
      var.create ? kubernetes_cluster_role_v1.cr[0].metadata[0].name : var.name
    )
  }

  dynamic "subject" {
    for_each = var.binding_subjects

    content {
      kind      = lookup(subject.value, "kind", null)
      name      = lookup(subject.value, "name", var.name)
      namespace = lookup(subject.value, "namespace", var.binding_namespace) # This value only applies to kind ServiceAccount.
      api_group = lookup(subject.value, "api_group",                        # This value only applies to kind User and Group.
        lookup(subject.value, "kind", null) == "User" || 
        lookup(subject.value, "kind", null) == "Group" ?
        "rbac.authorization.k8s.io" :
        null
      )
    }
  }
}

################################################################################
# Cluster Role Bindings
# https://kubernetes.io/docs/reference/access-authn-authz/rbac/#rolebinding-example
################################################################################
resource "kubernetes_cluster_role_binding_v1" "crb" {
  count = var.create && var.binding_namespace == null ? 1 : 0

  metadata {
    annotations = var.annotations
    # generate_name = var.generate_name
    labels      = var.labels
    name        = var.binding_name != null ? var.binding_name : var.name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = var.create ? kubernetes_cluster_role_v1.cr[0].metadata[0].name : var.name
  }

  dynamic "subject" {
    for_each = var.binding_subjects

    content {
      kind      = lookup(subject.value, "kind", "ClusterRole")
      name      = lookup(subject.value, "name", var.name)
      namespace = lookup(subject.value, "namespace", null) # This value only applies to kind ServiceAccount.
      api_group = lookup(subject.value, "api_group",       # This value only applies to kind User and Group.
        lookup(subject.value, "kind", null) == "User" || 
        lookup(subject.value, "kind", null) == "Group" ?
        "rbac.authorization.k8s.io" :
        null
      )
    }
  }
}
