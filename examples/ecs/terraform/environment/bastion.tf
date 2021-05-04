module "bastion" {
  source = "github.com/Originate/terraform-modules//aws/opsworks_bastion?ref=v1"

  stack = var.stack
  env   = terraform.workspace

  vpc_id              = module.vpc.id
  subnet_id           = module.vpc.public_subnet_ids[0]
  allowed_cidr_blocks = ["0.0.0.0/0"]
}
