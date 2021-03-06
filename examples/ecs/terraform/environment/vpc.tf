module "vpc" {
  source = "github.com/Originate/terraform-modules//aws/vpc?ref=v1"

  stack = var.stack
  env   = terraform.workspace

  az_count              = var.vpc_az_count
  cidr                  = var.vpc_cidr
  public_subnet_cidrs   = var.vpc_public_subnet_cidrs
  private_subnet_cidrs  = var.vpc_private_subnet_cidrs
  database_subnet_cidrs = var.vpc_database_subnet_cidrs
}
