################################################################################
# Role
# https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-example
################################################################################
resource "kubernetes_role_v1" "r" {
  count = var.create && var.create_role && var.role_name != null ? 1 : 0

  metadata {
    annotations = var.annotations
    # generate_name = var.generate_name
    labels    = var.labels
    name      = var.role_name
    namespace = var.role_namespace
  }

  dynamic "rule" {
    for_each = var.role_rules

    content {
      api_groups     = lookup(rule.value, "api_groups", null)
      resources      = lookup(rule.value, "resources", null)
      resource_names = lookup(rule.value, "resource_names", null)
      verbs          = lookup(rule.value, "verbs", null)
    }
  }
}

data "kubernetes_resource" "role" {
  count = var.create && !var.create_role && var.role_name != null ? 1 : 0

  api_version = "rbac.authorization.k8s.io/v1"
  kind        = "Role"

  metadata {
    name      = var.role_name
    namespace = var.role_namespace
  }
}

locals {
  role_name = (
    !var.create_role && var.role_name != null ?
    data.kubernetes_resource.role[0].object.metadata.name :
    null
  )
  # role_namespace = (
  #   !var.create_role && var.role_name != null ?
  #   data.kubernetes_resource.role[0].object.metadata.namespace :
  #   null
  # )
}

################################################################################
# Cluster Role
# https://kubernetes.io/docs/reference/access-authn-authz/rbac/#clusterrole-example
################################################################################
resource "kubernetes_cluster_role_v1" "cr" {
  count = var.create && var.create_cluster_role && var.cluster_role_name != null ? 1 : 0

  metadata {
    annotations = var.annotations
    # generate_name = var.generate_name
    labels = var.labels
    name   = var.cluster_role_name
  }

  dynamic "rule" {
    for_each = var.cluster_role_rules

    content {
      api_groups        = lookup(rule.value, "api_groups", null)
      resources         = lookup(rule.value, "resources", null)
      non_resource_urls = lookup(rule.value, "non_resource_urls", null)
      resource_names    = lookup(rule.value, "resource_names", null)
      verbs             = lookup(rule.value, "verbs", null)
    }
  }

  dynamic "aggregation_rule" {
    for_each = var.cluster_role_aggregation_rules

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

data "kubernetes_resource" "cluster_role" {
  count = var.create && !var.create_cluster_role && var.cluster_role_name != null ? 1 : 0

  api_version = "rbac.authorization.k8s.io/v1"
  kind        = "ClusterRole"

  metadata {
    name = var.cluster_role_name
  }
}

locals {
  cluster_role_name = (
    !var.create_cluster_role && var.cluster_role_name != null ?
    data.kubernetes_resource.cluster_role[0].object.metadata.name :
    null
  )
}

################################################################################
# Role Bindings
# https://kubernetes.io/docs/reference/access-authn-authz/rbac/#rolebinding-example
################################################################################
locals {
  role_binding_namespace = (
    var.role_binding_namespace != null ? var.role_binding_namespace : var.role_namespace
  )
}

resource "kubernetes_role_binding_v1" "rb" {
  count = var.create && var.role_binding_subjects != null ? 1 : 0

  metadata {
    annotations = var.annotations
    # generate_name = var.generate_name
    labels    = var.labels
    name      = var.role_binding_name != null ? var.role_binding_name : local.role_name
    namespace = local.role_binding_namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = var.role_namespace != null ? "Role" : "ClusterRole"
    name = (
      var.role_namespace != null ?
      var.create_role ? kubernetes_role_v1.r[0].metadata[0].name : local.role_name :
      var.create_cluster_role ? kubernetes_cluster_role_v1.cr[0].metadata[0].name : local.cluster_role_name
    )
  }

  dynamic "subject" {
    for_each = var.role_binding_subjects

    content {
      kind = lookup(subject.value, "kind", null)
      name = lookup(subject.value, "name",
        (
          var.role_namespace != null ?
          var.create_role ? kubernetes_role_v1.r[0].metadata[0].name : local.role_name :
          var.create_cluster_role ? kubernetes_cluster_role_v1.cr[0].metadata[0].name : local.cluster_role_name
        )
      )
      namespace = lookup(subject.value, "namespace", local.role_binding_namespace) # This value only applies to kind ServiceAccount.
      api_group = lookup(subject.value, "api_group",                               # This value only applies to kind User and Group.
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
  count = var.create && var.cluster_role_binding_subjects != null ? 1 : 0

  metadata {
    annotations = var.annotations
    # generate_name = var.generate_name
    labels = var.labels
    name   = var.cluster_role_binding_name != null ? var.cluster_role_binding_name : local.cluster_role_name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = var.create_cluster_role ? kubernetes_cluster_role_v1.cr[0].metadata[0].name : local.cluster_role_name
  }

  dynamic "subject" {
    for_each = var.cluster_role_binding_subjects

    content {
      kind      = lookup(subject.value, "kind", null)
      name      = lookup(subject.value, "name", local.cluster_role_name)
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
