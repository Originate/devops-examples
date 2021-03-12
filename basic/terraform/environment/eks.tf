module "eks" {
  source = "github.com/originate/terraform-modules/aws/eks"

  stack = var.stack
  env   = terraform.workspace

  kubernetes_version  = var.eks_kubernetes_version
  vpc_id              = module.vpc.id
  subnet_ids          = module.vpc.private_subnet_ids
  node_instance_class = var.eks_node_instance_class
  node_disk_size      = var.eks_node_disk_size
  node_count_min      = var.eks_node_count_min
  node_count_max      = var.eks_node_count_max

  kms_key_deletion_window_in_days = var.aws_kms_key_deletion_window_in_days

  aws_load_balancer_controller_version = var.eks_aws_load_balancer_controller_version

  # Creates a dependency on module.vpc to ensure that the network doesn't break
  # down prior to Kubernetes resources getting cleaned up on destroy. Setting
  # `depends_on = [module.vpc]` directly creates an issue where Terraform panics
  # about not being able to determine the number of subnets ahead of time, so a
  # null_resource is used to create the dependency chain instead
  depends_on = [null_resource.vpc_dependency]
}

# Creates a dependency chain between module.eks and module.vpc, since module.eks
# cannot depend on module.vpc directly without causing Terraform errors
resource "null_resource" "vpc_dependency" {
  depends_on = [module.vpc]
}
