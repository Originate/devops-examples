locals {
  default_tags = {
    Terraform   = "true"
    Stack       = var.stack
    Environment = terraform.workspace
  }
}

module "aws" {
  source = "github.com/Originate/terraform-modules//aws/base_env?ref=0a5d76f"

  env          = terraform.workspace
  default_tags = local.default_tags

  base_domain = var.aws_base_domain
}
