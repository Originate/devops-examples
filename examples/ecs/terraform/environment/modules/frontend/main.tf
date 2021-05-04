locals {
  container_port    = 8080
  health_check_path = "/"
}

module "ecs_application" {
  source = "github.com/Originate/terraform-modules//aws/ecs_application?ref=v1"

  name                       = "frontend"
  cluster_name               = var.ecs_cluster_name
  cluster_arn                = var.ecs_cluster_arn
  docker_repo                = var.docker_repo
  docker_tag                 = var.docker_tag
  container_port             = local.container_port
  health_check_path          = local.health_check_path
  run_as_user                = 101 # nginx
  run_as_group               = 101 # nginx
  desired_count              = var.desired_count
  cpu                        = var.cpu
  memory                     = var.memory
  vpc_id                     = var.vpc_id
  subnet_ids                 = var.subnet_ids
  task_execution_role_arn    = var.task_execution_role_arn
  allowed_security_group_ids = [var.alb_security_group_id]
  cloudwatch_log_group_name  = var.cloudwatch_log_group_name
}
