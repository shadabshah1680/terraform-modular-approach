locals {
  cluster_version = "1.24"
  public_subnet_ids = [
    for subnet in var.vpc_config.public_subnets : subnet.id
  ]
  private_subnet_ids = [
    for subnet in var.vpc_config.private_subnets : subnet.id
  ]
  vpc_id = var.vpc_config.vpc.id
  arn_parts = split("/", var.cluster_config.userarn)
  username = element(local.arn_parts, 3)
  arn_part1 = element(local.arn_parts, 4)
  account_id_raw=split(":",local.arn_part1)
  account_id=element(local.account_id_raw, 4)
}