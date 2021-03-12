provider "aws" {
  region              = var.region
  allowed_account_ids = [var.account_id]
  profile             = var.profile
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name, "--profile", var.profile]
      command     = "aws"
    }
  }
}

provider "kubectl" {
  load_config_file = false

  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name, "--profile", var.profile]
    command     = "aws"
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  # Using exec-based configuration rather than outputting a token from an
  # aws_eks_cluster_auth data source to avoid expiration in the middle of a
  # Terraform apply operation (EKS tokens expire within 15 minutes):
  # https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/guides/getting-started#provider-setup
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name, "--profile", var.profile]
    command     = "aws"
  }
}
