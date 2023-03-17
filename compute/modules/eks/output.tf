output "region_name" {
  value = data.aws_region.current.name
}
output "config-map-aws-auth" {
  value = "${local.config-map-aws-auth}"
}

output "kubeconfig" {
  value = "${local.kubeconfig}"
}
