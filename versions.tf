terraform {
  required_version = ">= 0.13.1"

  experiments = [module_variable_optional_attrs]

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.7.0"
    }
  }
}
