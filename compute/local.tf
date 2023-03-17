locals {
  config  = yamldecode(file("config/${terraform.workspace}/configfile.yml"))
  vpc_config = data.terraform_remote_state.vpc.outputs.vpc.output
  cluster_config = local.config.cluster_config
  tags = {
    Environment = "${terraform.workspace}",
    Terraform = "true",
    Project = local.config.project_name
  }
}
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "shadab-terraform-backend"
    key    = "network/dev/backend.tfstate"
    region = "us-west-2"
  }
}