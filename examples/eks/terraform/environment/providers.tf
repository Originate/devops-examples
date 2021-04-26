locals {
  # Initially uses the caller's identity directly for cluster authentication,
  # meaning that the cluster_creator of the EKS cluster will be the IAM user or
  # role used to initially run this Terraform configuration. Once an admin IAM
  # role has been created and added to the aws_auth ConfigMap, subsequent
  # Terraform runs will assume the admin IAM role for cluster authentication.
  #
  # For information about EKS cluster authentication:
  #
  # - https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html
  # - https://aws.amazon.com/premiumsupport/knowledge-center/amazon-eks-cluster-access/
  eks_credentials_exec_args = concat(
    [
      "eks", "get-token",
      "--cluster-name", module.eks.cluster_name,
      "--profile", var.profile
    ],
    can(data.terraform_remote_state.self.outputs.eks_login_command) ? [
      "--role-arn", module.eks.admin_iam_role_arn,
    ] : []
  )
}

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
      args        = local.eks_credentials_exec_args
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
    args        = local.eks_credentials_exec_args
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
    args        = local.eks_credentials_exec_args
    command     = "aws"
  }
}
