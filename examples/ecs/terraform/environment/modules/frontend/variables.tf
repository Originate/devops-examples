variable "default_tags" {
  description = "Default tags to add to AWS resources"
  type        = map(string)
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster where the service should run"
  type        = string
}

variable "ecs_cluster_arn" {
  description = "The ARN of the ECS cluster where the service should run"
  type        = string
}

variable "docker_repo" {
  description = "The repository of the Docker image to deploy"
  type        = string
}

variable "docker_tag" {
  description = "The tag of the Docker image to deploy"
  type        = string
}

variable "desired_count" {
  description = "The desired number of instances per service"
  type        = number
}

variable "cpu" {
  description = "The hard limit of CPU units to present for the task (for available options, see https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#task_size)"
  type        = number
}

variable "memory" {
  description = "The hard limit of memory (in MiB) to present to the task (for available options, see https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#task_size)"
  type        = number
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "The list of subnet IDs to place ECS tasks"
  type        = list(string)
}

variable "task_execution_role_arn" {
  description = "The ARN of the ECS task execution IAM role"
  type        = string
}

variable "alb_security_group_id" {
  description = "The ID of security group associated with the ALB"
  type        = string
}

variable "cloudwatch_log_group_name" {
  description = "The name of the CloudWatch Log Group to write log streams"
  type        = string
}
