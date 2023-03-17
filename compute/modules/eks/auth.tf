locals {
  config-map-aws-auth = <<CONFIGMAPAWSAUTH
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.node.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH

  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.eks.endpoint}
    certificate-authority-data: ${aws_eks_cluster.eks.certificate_authority.0.data}
  name: ${var.cluster_config.cluster_name}
contexts:
- context:
    cluster: ${var.cluster_config.cluster_name}
    user: ${var.cluster_config.cluster_name}
  name: ${var.cluster_config.cluster_name}
current-context: ${var.cluster_config.cluster_name}
kind: Config
preferences: {}
users:
- name: ${var.cluster_config.cluster_name}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws
      args:
        - "eks"
        - "get-token"
        - "--cluster-name"
        - "${var.cluster_config.cluster_name}"
        - "--region"
        - "${data.aws_region.current.name}"
KUBECONFIG
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = <<-EOF
      - rolearn: ${aws_iam_role.node.arn}
        username: system:node:{{EC2PrivateDNSName}}
        groups:
          - system:bootstrappers
          - system:nodes
      - rolearn: ${var.cluster_config.userarn}
        username: cluster_admin_user:${local.username}
        groups:
          - system:masters

    EOF
  }


#   api_version = "v1"
#   kind        = "ConfigMap"
}
resource "kubernetes_role_binding" "my_user_binding" {
  metadata {
    name = "my-user-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "User"
    name      = local.username
  }
  depends_on = [
    kubernetes_config_map.aws_auth
  ]
}