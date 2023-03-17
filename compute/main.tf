module "eks" {
    source = "./modules/eks"
    vpc_config = local.vpc_config
    cluster_config = local.cluster_config
    tags = local.tags 
}
