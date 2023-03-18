

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
