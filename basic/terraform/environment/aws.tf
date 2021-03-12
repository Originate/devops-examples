module "aws" {
  source = "github.com/originate/terraform-modules/aws/base_env"

  stack = var.stack
  env   = terraform.workspace

  base_domain = var.aws_base_domain
}
