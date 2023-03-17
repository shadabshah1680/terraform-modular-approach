

# ################################################################################
# # EKS Module
# ################################################################################



resource "aws_eks_cluster" "eks" {
  name = var.cluster_config.cluster_name

  version = var.cluster_config.k8s_version

  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.vpc_config.id]
    subnet_ids         = local.private_subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSServicePolicy,
  ]
}
module "eks_managed_node_group" {
  source = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"

  name            = "ng"
  cluster_name    = aws_eks_cluster.eks.name
  cluster_version = "1.24"
  create = true

  subnet_ids = local.public_subnet_ids

  // The following variables are necessary if you decide to use the module outside of the parent EKS module context.
  // Without it, the security groups of the nodes are empty and thus won't join the cluster.
  cluster_primary_security_group_id = aws_security_group.vpc_config.id
  vpc_security_group_ids            = [aws_security_group.vpc_config.id]

  // Note: `disk_size`, and `remote_access` can only be set when using the EKS managed node group default launch template
  // This module defaults to providing a custom launch template to allow for custom security groups, tag propagation, etc.
  // use_custom_launch_template = false
  disk_size = 20
  //
  //  # Remote access cannot be specified with a launch template
  //  remote_access = {
  //    ec2_ssh_key               = module.key_pair.key_pair_name
  //    source_security_group_ids = [aws_security_group.remote_access.id]
  //  }

  min_size     = 1
  max_size     = 1
  desired_size = 1

  instance_types = ["t3a.small"]
  capacity_type  = "ON_DEMAND"

  labels = {
    Environment = "test"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  tags = var.tags
}
