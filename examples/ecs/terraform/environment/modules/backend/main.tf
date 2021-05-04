locals {
  name              = "backend"
  container_port    = 3000
  health_check_path = "/api/healthcheck"
}

resource "aws_ssm_parameter" "pghost" {
  name        = "${var.secrets_prefix}/${local.name}/rds/pghost"
  description = "The hostname of the RDS instance"
  type        = "String"
  value       = module.rds.host

  tags = var.default_tags
}

resource "aws_ssm_parameter" "pgport" {
  name        = "${var.secrets_prefix}/${local.name}/rds/pgport"
  description = "The RDS port"
  type        = "String"
  value       = module.rds.port

  tags = var.default_tags
}

resource "aws_ssm_parameter" "pgdatabase" {
  name        = "${var.secrets_prefix}/${local.name}/rds/pgdatabase"
  description = "The name of the SQL database"
  type        = "String"
  value       = module.rds.database

  tags = var.default_tags
}

resource "aws_ssm_parameter" "pguser" {
  name        = "${var.secrets_prefix}/${local.name}/rds/pguser"
  description = "The RDS database username"
  type        = "SecureString"
  value       = module.rds.username
  key_id      = var.secrets_kms_key_id

  tags = var.default_tags
}

resource "aws_ssm_parameter" "pgpassword" {
  name        = "${var.secrets_prefix}/${local.name}/rds/pgpassword"
  description = "The RDS database password"
  type        = "SecureString"
  value       = module.rds.password
  key_id      = var.secrets_kms_key_id

  tags = var.default_tags
}

resource "aws_ssm_parameter" "pgsslmode" {
  name        = "${var.secrets_prefix}/${local.name}/rds/pgsslmode"
  description = "The RDS connection SSL mode"
  type        = "String"
  value       = "no-verify"

  tags = var.default_tags
}

module "ecs_application" {
  source = "github.com/Originate/terraform-modules//aws/ecs_application?ref=v1"

  default_tags = var.default_tags

  name                       = local.name
  cluster_name               = var.ecs_cluster_name
  cluster_arn                = var.ecs_cluster_arn
  docker_repo                = var.docker_repo
  docker_tag                 = var.docker_tag
  container_port             = local.container_port
  health_check_path          = local.health_check_path
  desired_count              = var.desired_count
  cpu                        = var.cpu
  memory                     = var.memory
  vpc_id                     = var.vpc_id
  subnet_ids                 = var.subnet_ids
  task_execution_role_arn    = var.task_execution_role_arn
  allowed_security_group_ids = [var.alb_security_group_id]
  cloudwatch_log_group_name  = var.cloudwatch_log_group_name

  environment_variables = {
    PORT = local.container_port
  }

  environment_secrets_arns = {
    PGHOST     = aws_ssm_parameter.pghost.arn
    PGPORT     = aws_ssm_parameter.pgport.arn
    PGDATABASE = aws_ssm_parameter.pgdatabase.arn
    PGUSER     = aws_ssm_parameter.pguser.arn
    PGPASSWORD = aws_ssm_parameter.pgpassword.arn
    PGSSLMODE  = aws_ssm_parameter.pgsslmode.arn
  }
}
