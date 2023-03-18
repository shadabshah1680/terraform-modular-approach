module "eks_managed_node_group" {
  source = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"

  name            = "ng"
  cluster_name    = aws_eks_cluster.eks.name
  cluster_version = var.cluster_config.k8s_version
  create = true

  subnet_ids = local.public_subnet_ids
  cluster_primary_security_group_id = aws_security_group.vpc_config.id
  vpc_security_group_ids            = [aws_security_group.vpc_config.id]
  disk_size = 20
  min_size     = var.cluster_config.scaling_config.min_size
  max_size     = var.cluster_config.scaling_config.max_size
  desired_size = var.cluster_config.scaling_config.desired_size

  instance_types = ["t3a.small"]
  capacity_type  = "ON_DEMAND"

  labels = var.tags

  tags = var.tags
}
