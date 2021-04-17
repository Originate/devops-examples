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

resource "kubernetes_namespace" "stack" {
  metadata {
    name = var.stack
  }

  # Ensures all Kubernetes resources get deleted before removing the cluster
  # during a destroy operation
  depends_on = [module.eks]
}

module "ingress" {
  source = "github.com/Originate/terraform-modules//kubernetes/alb_ingress?ref=d679df0"

  default_tags = local.default_tags

  kubernetes_namespace = kubernetes_namespace.stack.metadata[0].name
  route53_zone_id      = module.aws.route53_zone_id
  acm_certificate_arn  = module.aws.acm_certificate_arn

  ingress_rules = {
    "" = {
      paths = [
        {
          pattern      = "/api/*"
          service_name = module.backend.service_name
          service_port = module.backend.service_port
        },
        {
          pattern      = "/*"
          service_name = module.frontend.service_name
          service_port = module.frontend.service_port
        }
      ]
    }
  }
}

module "docker_push_frontend" {
  source = "github.com/Originate/terraform-modules//docker/push?ref=d679df0"

  repo          = data.aws_ecr_repository.service["frontend"].repository_url
  tag           = local.docker_tags["frontend"]
  login_command = local.ecr_login_command

  build_updated_images = true
  context_path         = "${path.module}/../../frontend"
  additional_tags      = ["latest"]
}

module "frontend" {
  source = "./modules/frontend"

  kubernetes_namespace = kubernetes_namespace.stack.metadata[0].name
  docker_repo          = data.aws_ecr_repository.service["frontend"].repository_url
  docker_tag           = local.docker_tags["frontend"]
  autoscale_max        = 1
  autoscale_min        = 1

  depends_on = [module.docker_push_frontend]
}

module "docker_push_backend" {
  source = "github.com/Originate/terraform-modules//docker/push?ref=d679df0"

  repo          = data.aws_ecr_repository.service["backend"].repository_url
  tag           = local.docker_tags["backend"]
  login_command = local.ecr_login_command

  build_updated_images = true
  context_path         = "${path.module}/../../backend"
  additional_tags      = ["latest"]
}

module "backend" {
  source = "./modules/backend"

  kubernetes_namespace = kubernetes_namespace.stack.metadata[0].name
  docker_repo          = data.aws_ecr_repository.service["backend"].repository_url
  docker_tag           = local.docker_tags["backend"]
  autoscale_max        = 1
  autoscale_min        = 1
  rds_attributes       = local.rds_attributes

  depends_on = [module.docker_push_backend]
}
