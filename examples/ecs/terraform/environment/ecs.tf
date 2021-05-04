module "ecs" {
  source = "github.com/Originate/terraform-modules//aws/ecs_cluster?ref=v1"

  stack = var.stack
  env   = terraform.workspace

  kms_key_deletion_window_in_days = var.aws_kms_key_deletion_window_in_days
}
