data "aws_availability_zones" "available" {}
locals {
  default_tags = {
    Environment = terraform.workspace
    Name        = var.project_name
  }

  tags = merge(local.default_tags, var.tags)

  ### Created Subnets from for_each loop, so we can reference them easily
  public_subnets = values(aws_subnet.public_subnets)
  private_subnets      = values(aws_subnet.private_subnets)
}