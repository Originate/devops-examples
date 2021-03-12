module "bastion" {
  source = "github.com/originate/terraform-modules/custom/kubernetes_bastion"

  profile = var.profile
  stack   = var.stack
  env     = terraform.workspace

  ssh_port = var.bastion_ssh_port

  # Ensures all bastion host Kubernetes resources get deleted before removing
  # the cluster during a destroy operation
  depends_on = [module.eks]
}
