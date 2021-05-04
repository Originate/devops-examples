locals {
  docker_tags = {
    for name, tag in var.override_docker_tags :
    name => try(coalesce(tag, var.universal_override_docker_tag), data.terraform_remote_state.self.outputs.last_deployed_docker_tags[name])
  }
}

# Requires adding the ECR repository to the var.override_docker_tags object in
# this module and the var.ecr_repository_names in the global configuration
# module (also requires applying the updated global configuration first)
data "aws_ecr_repository" "service" {
  for_each = local.docker_tags

  name = "${var.stack}/${each.key}"
}

module "alb" {
  source = "github.com/Originate/terraform-modules//aws/alb?ref=v1"

  stack = var.stack
  env   = terraform.workspace

  vpc_id              = module.vpc.id
  subnet_ids          = module.vpc.public_subnet_ids
  route53_zone_id     = module.aws.route53_zone_id
  subdomains          = ["", "*"]
  acm_certificate_arn = module.aws.acm_certificate_arn

  ingress_rules = {
    "" = {
      paths = [
        {
          pattern          = "/api/*"
          target_group_arn = module.backend.target_group_arn
        },
        {
          pattern          = "/*"
          target_group_arn = module.frontend.target_group_arn
        }
      ]
    }
  }
}

module "docker_push_frontend" {
  source = "github.com/Originate/terraform-modules//docker/push?ref=v1"

  repo          = data.aws_ecr_repository.service["frontend"].repository_url
  tag           = local.docker_tags["frontend"]
  login_command = local.ecr_login_command

  build_updated_images = var.build_updated_docker_images
  context_path         = "${path.module}/../../../../basic_app/frontend"
  additional_tags      = var.additional_docker_tags
}

module "frontend" {
  source = "./modules/frontend"

  ecs_cluster_name          = module.ecs.cluster_name
  ecs_cluster_arn           = module.ecs.cluster_arn
  docker_repo               = data.aws_ecr_repository.service["frontend"].repository_url
  docker_tag                = local.docker_tags["frontend"]
  desired_count             = 1
  cpu                       = 256
  memory                    = 512
  vpc_id                    = module.vpc.id
  subnet_ids                = module.vpc.private_subnet_ids
  task_execution_role_arn   = module.ecs.task_execution_role_arn
  alb_security_group_id     = module.alb.security_group_id
  cloudwatch_log_group_name = module.ecs.cloudwatch_log_group_name

  depends_on = [module.docker_push_frontend]
}

module "docker_push_backend" {
  source = "github.com/Originate/terraform-modules//docker/push?ref=v1"

  repo          = data.aws_ecr_repository.service["backend"].repository_url
  tag           = local.docker_tags["backend"]
  login_command = local.ecr_login_command

  build_updated_images = var.build_updated_docker_images
  context_path         = "${path.module}/../../../../basic_app/backend"
  additional_tags      = var.additional_docker_tags
}

module "backend" {
  source = "./modules/backend"

  ecs_cluster_name          = module.ecs.cluster_name
  ecs_cluster_arn           = module.ecs.cluster_arn
  docker_repo               = data.aws_ecr_repository.service["backend"].repository_url
  docker_tag                = local.docker_tags["backend"]
  desired_count             = 1
  cpu                       = 256
  memory                    = 512
  vpc_id                    = module.vpc.id
  subnet_ids                = module.vpc.private_subnet_ids
  task_execution_role_arn   = module.ecs.task_execution_role_arn
  alb_security_group_id     = module.alb.security_group_id
  bastion_security_group_id = module.bastion.security_group_id
  secrets_prefix            = module.ecs.secrets_prefix
  secrets_kms_key_id        = module.ecs.secrets_kms_key_id
  cloudwatch_log_group_name = module.ecs.cloudwatch_log_group_name
  rds_attributes            = local.rds_attributes

  depends_on = [module.docker_push_backend]
}
