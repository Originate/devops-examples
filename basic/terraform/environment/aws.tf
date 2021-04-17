locals {
  default_tags = {
    Terraform   = "true"
    Stack       = var.stack
    Environment = terraform.workspace
  }
  # Retry a few times because Docker can be flakey with multiple concurrent
  # login attempts on macOS, which can happen if multiple Docker pushes get
  # triggered around the same time
  ecr_login_command = <<-EOT
    for i in {1..5}; do
      if aws ecr get-login-password --profile '${var.profile}' --region '${var.region}' | docker login --username AWS --password-stdin '${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com'; then
        break
      fi
      sleep 1
    done
  EOT
}

data "aws_caller_identity" "current" {}

module "aws" {
  source = "github.com/Originate/terraform-modules//aws/base_env?ref=c50291f"

  env          = terraform.workspace
  default_tags = local.default_tags

  base_domain = var.aws_base_domain
}
