variable "create" {
  description = "Controls whether the RBAC resources should be created (affects all resources)."
  type        = bool
  default     = true
}

variable "annotations" {
  description = "An unstructured key value map stored with the role that may be used to store arbitrary metadata."
  type        = map(string)
  default     = {}
}

variable "labels" {
  description = "Map of string keys and values that can be used to organize and categorize (scope and select) the role."
  type        = map(string)
  default     = {}
}

variable "create_role" {
  description = "Whether to create a role with `name`."
  type        = bool
  default     = true
}

# https://github.com/hashicorp/terraform-provider-kubernetes/issues/588
# variable "role_generate_name" {
#   description = <<-EOT
#     Prefix, used by the server, to generate a unique name. This value will also be combined with a unique suffix.
#     Only one of `name` or `generate_name` can be provide.
#     EOT
#   type        = string
#   default     = null
#   nullable    = true
# }

variable "role_name" {
  description = "The name of a role."
  type        = string
  default     = null
  nullable    = true
}

variable "role_namespace" {
  description = "The namespace in which a role belong."
  type        = string
  default     = null
  nullable    = true
}

variable "role_rules" {
  description = "List of rules that define the set of permissions for a role."
  type = list(any
    # object({
    #     api_groups     = optional(list(string))
    #     resources      = list(string)
    #     resource_names = optional(list(string))
    #     verbs          = list(string)
    # }),
  )
  default = []
}

variable "role_binding_name" {
  description = <<-EOT
  The name of the role binding.
  EOT
  type        = string
  default     = null
  nullable    = true
}

variable "role_binding_namespace" {
  description = "The namespace in which the role binding belongs."
  type        = string
  default     = null
  nullable    = true
}

variable "role_binding_subjects" {
  description = "The Users, Groups, or ServiceAccounts to grant permissions to."
  type = list(any
    # object({
    #     kind      = string
    #     name      = string
    #     namespace = optional(string)
    #     api_group = optional(string)
    # }),
  )
  default  = null
  nullable = true
}

variable "create_cluster_role" {
  description = "Whether to create a cluster role with `name`."
  type        = bool
  default     = true
}

variable "cluster_role_name" {
  description = "The name of a cluster role."
  type        = string
  default     = null
  nullable    = true
}

variable "cluster_role_rules" {
  description = "List of rules that define the set of permissions for a cluster role."
  type = list(any
    # object({
    #     api_groups     = optional(list(string))
    #     resources      = list(string)
    #     resource_names = optional(list(string))
    #     verbs          = list(string)
    # }),
  )
  default  = null
  nullable = true
}

variable "cluster_role_aggregation_rules" {
  description = <<-EOT
  Describes how to build the rules for a cluster role.
  The rules are controller managed and direct changes to rules will be overwritten by the controller.
  EOT
  type = list(any
    # object({
    #     cluster_role_selectors = list(
    #         object({
    #             match_labels = map(string)
    #             match_expressions = list(
    #                 object({
    #                     key = string
    #                     operator = string
    #                     values = list(string)
    #                 })
    #             )
    #         })
    #     )
    # })
  )
  default = []
}

variable "cluster_role_binding_name" {
  description = <<-EOT
  The name of the cluster role binding.
  EOT
  type        = string
  default     = null
  nullable    = true
}

variable "cluster_role_binding_subjects" {
  description = "The Users, Groups, or ServiceAccounts to grant permissions to."
  type = list(any
    # object({
    #     kind      = string
    #     name      = string
    #     namespace = optional(string)
    #     api_group = optional(string)
    # }),
  )
  default  = null
  nullable = true
}
