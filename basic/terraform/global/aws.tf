locals {
  default_tags = {
    Terraform   = "true"
    Stack       = var.stack
    Environment = var.env
  }
}

module "aws" {
  source = "github.com/Originate/terraform-modules//aws/base_global?ref=c50291f"

  stack        = var.stack
  default_tags = local.default_tags

  domain               = var.domain
  ecr_repository_names = var.ecr_repository_names
}
