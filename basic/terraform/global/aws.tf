module "aws" {
  source = "github.com/originate/terraform-modules/aws/base_global"

  stack = var.stack
  env   = var.env

  domain     = var.domain
  repo_names = var.repo_names
}
