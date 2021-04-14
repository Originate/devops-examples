locals {
  default_tags = {
    Terraform   = "true"
    Stack       = var.stack
    Environment = terraform.workspace
  }
  ecr_login_command = "aws ecr get-login-password --profile '${var.profile}' --region '${var.region}' | docker login --username AWS --password-stdin '${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com'"
}

data "aws_caller_identity" "current" {}

module "aws" {
  source = "github.com/Originate/terraform-modules//aws/base_env?ref=c50291f"

  env          = terraform.workspace
  default_tags = local.default_tags

  base_domain = var.aws_base_domain
}
