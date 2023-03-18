terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.6.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}
provider "kubectl" {
  host                   = aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)
  load_config_file       = false
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_config.cluster_name]
    command     = "aws"

  }
}
provider "kubernetes" {
  host                   = aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_config.cluster_name]
    command     = "aws"
  }
}
provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_config.cluster_name]
      command     = "aws"
    }
  }
}
resource "null_resource" "wait_for_nodegroup" {
  depends_on = [
    module.eks_managed_node_group
  ]
  provisioner "local-exec" {
    command = "until [ $(kubectl get nodes | grep -c ' Ready') -eq ${var.cluster_config.scaling_config.desired_size} ]; do sleep 10; done"
  }
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress-controller"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  depends_on = [
    null_resource.wait_for_nodegroup,
    kubectl_manifest.pod
  ]
}
# resource "null_resource" "apply_manifests" {
#   provisioner "local-exec" {
#     command = "kubectl apply -f pod.yaml -n kube-system"
#   }
# }
# resource "null_resource" "apply_helm" {
#   provisioner "local-exec" {
#     command = "helm upgrade -i shadab chart  -f Values.yaml  --set deployment.image.repository=nginx --set deployment.image.tag=latest"
#   }
# }

resource "kubectl_manifest" "pod" {
  yaml_body = file("${path.module}/pod.yaml")
}
resource "helm_release" "mychart" {
  name       = "mychart"
  repository = null
  chart      = "${path.module}/chart"
  values = [
    file("${path.module}/chart/values.yaml"),
  ]
  set {
    name  = "image.tag"
    value = "latest"
  }
  set {
    name  = "image.repository"
    value = "nginx"
  }
}
