resource "aws_ecr_repository" "bastion" {
  name = "${var.stack}-${terraform.workspace}-bastion"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.default_tags
}

module "bastion" {
  source = "github.com/Originate/terraform-modules//kubernetes/bastion?ref=0a5d76f"

  ssh_port             = var.bastion_ssh_port
  repo_url             = aws_ecr_repository.bastion.repository_url
  docker_login_command = "eval '$(aws ecr get-login --no-include-email --profile ${var.profile})'"


  # Ensures all bastion host Kubernetes resources get deleted before removing
  # the cluster during a destroy operation
  depends_on = [module.eks]
}
