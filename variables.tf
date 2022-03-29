variable "create" {
  description = "Controls whether the Authorization and RBAC resources should be created (affects all resources)."
  type        = bool
  default     = true
}

variable "labels" {
  description = "The global labels. Applied to all resources."
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "The global annotations. Applied to all resources."
  type        = map(string)
  default     = {}
}

variable "roles" {
  description = "The roles to bind to the service account. Set `create = false` to use pre-existing role."
  type        = any
  default     = {}
}

variable "cluster_roles" {
  description = "The cluster roles to bind to the service account. Set `create = false` to use pre-existing cluster role."
  type        = any
  default     = {}
}
