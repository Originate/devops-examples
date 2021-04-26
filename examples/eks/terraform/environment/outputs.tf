output "secrets" {
  value     = local.secrets
  sensitive = true
}

output "last_deployed_docker_tags" {
  value = local.docker_tags
}

output "eks_login_command" {
  value = "aws eks update-kubeconfig --name '${module.eks.cluster_name}' --role-arn '${module.eks.admin_iam_role_arn}' --profile '${var.profile}'"

  # Only create after the entire module has been successfully provisioned
  depends_on = [module.eks]
}
