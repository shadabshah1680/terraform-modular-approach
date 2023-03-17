variable "vpc_config" {
  default = {}
}
variable "cluster_config" {
  default = {}
}
variable "project_name" {
  default = ""
}
variable "tags" {
  default = {}  
}
variable "dummy_kubeapi_server" {
  default = null
}

variable "map_additional_iam_roles" {
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  description = "Additional IAM roles to add to `config-map-aws-auth` ConfigMap"
  default     = []
}