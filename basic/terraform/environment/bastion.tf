resource "aws_ecr_repository" "bastion" {
  name = "${var.stack}-${terraform.workspace}-bastion"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Terraform   = "true"
    Stack       = var.stack
    Environment = terraform.workspace
  }
}

module "bastion" {
  source = "github.com/originate/terraform-modules/custom/kubernetes_bastion"

  ssh_port             = var.bastion_ssh_port
  repo_url             = aws_ecr_repository.bastion.repository_url
  docker_login_command = "eval '$(aws ecr get-login --no-include-email --profile ${var.profile})'"


  # Ensures all bastion host Kubernetes resources get deleted before removing
  # the cluster during a destroy operation
  depends_on = [module.eks]
}
