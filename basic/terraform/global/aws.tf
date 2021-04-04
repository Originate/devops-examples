locals {
  default_tags = {
    Terraform   = "true"
    Stack       = var.stack
    Environment = var.env
  }
}

module "aws" {
  source = "github.com/Originate/terraform-modules//aws/base_global?ref=0a5d76f"

  stack        = var.stack
  default_tags = local.default_tags

  domain     = var.domain
  repo_names = var.repo_names
}
