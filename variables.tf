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
  description = "The roles and associated role bindings."
  type        = any
  default     = {}
}

variable "cluster_roles" {
  description = "The cluster roles and associated cluster role bindings or role bindings."
  type        = any
  default     = {}
}
