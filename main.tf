module "vpc" {
    source = "./modules/network"
    vpc_config = local.config.vpc
    project_name= local.config.project_name
  
}