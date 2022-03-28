variable "name" {
  description = "The service account name."
  type        = string
}

variable "namespace" {
  description = "The namespace name."
  type        = string
  default     = "default"
}

variable "additional_labels" {
  description = "Additional labels."
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "The service account annotations."
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
