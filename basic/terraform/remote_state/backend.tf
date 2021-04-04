locals {
  default_tags = {
    Terraform   = "true"
    Stack       = var.stack
    Environment = var.env
  }
}

module "backend" {
  source = "github.com/Originate/terraform-modules//aws/s3_terraform_backend?ref=0a5d76f"

  stack        = var.stack
  default_tags = local.default_tags

  config_output_path              = "${path.module}/../config/backend_config.tfvars"
  profile                         = var.profile
  kms_key_deletion_window_in_days = 7
}
