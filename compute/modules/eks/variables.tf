variable "vpc_config" {
}

variable "tags" {
  
}
variable "cluster_config" {
  
}
# variable "aws_auth_yaml_strip_quotes" {
#   type        = bool
#   description = "If true, remove double quotes from the generated aws-auth ConfigMap YAML to reduce spurious diffs in plans"
#   default     = true
# }
# variable "apply_config_map_aws_auth" {
#   type        = bool
#   description = "Whether to apply the ConfigMap to allow worker nodes to join the EKS cluster and allow additional users, accounts and roles to acces the cluster"
#   default     = true
# }
# variable "enabled" {
#   type = bool
#   default = true
# }
# variable "kube_exec_auth_enabled" {
#   type        = bool
#   description = <<-EOT
#     If `true`, use the Kubernetes provider `exec` feature to execute `aws eks get-token` to authenticate to the EKS cluster.
#     Disabled by `kubeconfig_path_enabled`, overrides `kube_data_auth_enabled`.
#     EOT
#   default     = false
# }
# variable "kube_data_auth_enabled" {
#   type        = bool
#   description = <<-EOT
#     If `true`, use an `aws_eks_cluster_auth` data source to authenticate to the EKS cluster.
#     Disabled by `kubeconfig_path_enabled` or `kube_exec_auth_enabled`.
#     EOT
#   default     = true
# }
# variable "kube_exec_auth_aws_profile_enabled" {
#   type        = bool
#   description = "If `true`, pass `kube_exec_auth_aws_profile` as the `profile` to `aws eks get-token`"
#   default     = false
# }


# variable "kube_exec_auth_aws_profile" {
#   type        = string
#   description = "The AWS config profile for `aws eks get-token` to use"
#   default     = ""
# }
# variable "kube_exec_auth_role_arn_enabled" {
#   type        = bool
#   description = "If `true`, pass `kube_exec_auth_role_arn` as the role ARN to `aws eks get-token`"
#   default     = false
# }
# variable "kube_exec_auth_role_arn" {
#   type        = string
#   description = "The role ARN for `aws eks get-token` to use"
#   default     = ""
# }
# variable "apply_config_map_aws_auth" {
#   type        = bool
#   description = "Whether to apply the ConfigMap to allow worker nodes to join the EKS cluster and allow additional users, accounts and roles to acces the cluster"
#   default     = true
# }
