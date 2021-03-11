module "backend" {
  source = "github.com/originate/terraform-modules/custom/s3_terraform_backend"

  stack = var.stack
  env   = var.env

  config_output_path              = "${path.module}/../config/backend_config.tfvars"
  profile                         = var.profile
  kms_key_deletion_window_in_days = 7
}
