locals {
  default_tags = {
    Terraform   = "true"
    Stack       = var.stack
    Environment = var.env
  }
}

module "aws" {
  source = "github.com/Originate/terraform-modules//aws/base_global?ref=v1"

  stack        = var.stack
  default_tags = local.default_tags

  domain                  = var.domain
  ecr_keep_image_count    = var.ecr_keep_image_count
  ecr_preserve_image_tags = var.ecr_preserve_image_tags
  ecr_repository_names    = var.ecr_repository_names
}
