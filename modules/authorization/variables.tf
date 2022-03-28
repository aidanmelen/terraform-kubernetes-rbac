variable "create" {
  description = "Controls whether the RBAC resources should be created (affects all resources)."
  type        = bool
  default     = true
}

variable "create_role" {
  description = "Whether to create a role or cluster role with `name`. Otherwise, use an existing role or cluster role with `name`."
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

# https://github.com/hashicorp/terraform-provider-kubernetes/issues/588
# variable "generate_name" {
#   description = <<-EOT
#     Prefix, used by the server, to generate a unique name. This value will also be combined with a unique suffix.
#     Only one of `name` or `generate_name` can be provide.
#     EOT
#   type        = string
#   default     = null
#   nullable    = true
# }

variable "name" {
  description = <<-EOT
  The name of a role or cluster role. Will be a role when `namespace` is provided.
  Otherwise this will be the name of a cluster role.
  EOT
  type        = string
  default     = null
  nullable    = true
}

variable "namespace" {
  description = "The namespace in which a role belong."
  type        = string
  default     = null
  nullable    = true
}

variable "rules" {
  description = <<-EOT
  List of rules that define the set of permissions for either a role or cluster role. Will be a role when `namespace` is provided.
  Otherwise this will be the name of a cluster role.
  EOT
  type = list(any
    # object({
    #     api_groups     = optional(list(string))
    #     resources      = list(string)
    #     resource_names = optional(list(string))
    #     verbs          = list(string)
    # }),
  )
}

variable "aggregation_rules" {
  description = <<-EOT
  Describes how to build the rules for a cluster role. The rules are controller managed and direct changes to rules will be overwritten by the controller.
  This is ignored when `namespace` is provided.
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

variable "binding_name" {
  description = <<-EOT
  The name of the role binding. 
  EOT
  type        = string
  default     = null
  nullable    = true
}

variable "binding_namespace" {
  description = <<-EOT
  "The namespace in which a role and role binding belong."
  If provided with cluster role, this will grant the permissions defined in that cluster role to resources inside `binding_namespace`.
  EOT
  type        = string
  default     = null
  nullable    = true
}

variable "binding_subjects" {
  description = "The Users, Groups, or ServiceAccounts to grand permissions to."
  type = list(any
    # object({
    #     kind      = string
    #     name      = string
    #     namespace = optional(string)
    #     api_group = optional(string)
    # }),
  )
}
