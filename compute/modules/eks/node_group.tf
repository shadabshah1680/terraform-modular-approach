# resource "aws_eks_node_group" "eks-node-group" {
#   cluster_name    = var.cluster_config.cluster_name
#   node_group_name = "${var.cluster_config.cluster_name}-default-node-group"
#   node_role_arn   = aws_iam_role.node.arn
#   subnet_ids      = local.private_subnet_ids
#   scaling_config {
#     desired_size = var.cluster_config.scaling_config.desired_size
#     max_size     = var.cluster_config.scaling_config.max_size
#     min_size     = var.cluster_config.scaling_config.min_size
#   }
#   instance_types = var.cluster_config.instance_types
#   depends_on = [
#     aws_eks_cluster.eks,
#     aws_iam_role_policy_attachment.node-AmazonEKSWorkerNodePolicy,
#     aws_iam_role_policy_attachment.node-AmazonEKS_CNI_Policy
#   ]
#   tags = {
#     Name = "${var.cluster_config.cluster_name}-default-node-group"
#   }
# }

