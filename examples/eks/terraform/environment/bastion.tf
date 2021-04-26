module "bastion_ecr" {
  source = "github.com/Originate/terraform-modules//aws/ecr?ref=v1"

  stack        = var.stack
  default_tags = local.default_tags

  name             = "bastion/${terraform.workspace}"
  keep_image_count = 10
}

module "bastion" {
  source = "github.com/Originate/terraform-modules//kubernetes/bastion?ref=v1"

  ssh_port             = var.bastion_ssh_port
  docker_repo          = module.bastion_ecr.repository_url
  docker_login_command = local.ecr_login_command


  # Ensures all bastion host Kubernetes resources get deleted before removing
  # the cluster during a destroy operation
  depends_on = [module.eks]
}
