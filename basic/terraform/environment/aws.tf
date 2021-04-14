locals {
  default_tags = {
    Terraform   = "true"
    Stack       = var.stack
    Environment = terraform.workspace
  }
  ecr_login_command = "eval '$(aws ecr get-login --no-include-email --profile ${var.profile})'"
}

module "aws" {
  source = "github.com/Originate/terraform-modules//aws/base_env?ref=c50291f"

  env          = terraform.workspace
  default_tags = local.default_tags

  base_domain = var.aws_base_domain
}
