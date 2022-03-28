# module "pod_reader" {
#   source = "../../modules/authorization"

#   name      = "pod-reader"
#   namespace = "default"
#   rules = [
#     {
#       api_groups = [""]
#       resources  = ["pods"]
#       verbs      = ["get", "watch", "list"]
#     },
#   ]

#   binding_name = "read-pods"
#   binding_subjects = [
#     {
#       kind     = "User"
#       name     = "jane"
#       apiGroup = "rbac.authorization.k8s.io"
#     }
#   ]
# }
