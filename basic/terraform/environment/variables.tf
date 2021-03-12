# Root

variable "account_id" {
  description = "The ID of the AWS account in which resources are created"
  type        = string
}

variable "profile" {
  description = "The profile to use for accessing the AWS account"
  type        = string
}

variable "region" {
  description = "The AWS region"
  type        = string
}

variable "stack" {
  description = "The name of the stack"
  type        = string
}

variable "append_secrets" {
  description = "Override this value to add environment secrets the Terraform state (overwrites a value if it already exists and takes priority over var.remove_secrets)"
  type        = map(string)
  sensitive   = true
  default     = {}
}

variable "remove_secrets" {
  description = "Override this value to delete environment secrets (by key) from the Terraform state"
  type        = list(string)
  default     = []
}

# AWS

variable "aws_base_domain" {
  description = "The base domain name for the stack"
  type        = string
}

variable "aws_kms_key_deletion_window_in_days" {
  description = "Duration in days after which the key is deleted after destruction of the resource"
  type        = number

  validation {
    condition     = var.aws_kms_key_deletion_window_in_days >= 7 && var.aws_kms_key_deletion_window_in_days <= 30
    error_message = "The aws_kms_key_deletion_window_in_days value must be between 7 and 30 days, inclusive."
  }
}

# VPC

variable "vpc_az_count" {
  description = "The number of availability zones to use for the VPC"
  type        = number
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "vpc_public_subnet_cidrs" {
  description = "A list of CIDR blocks to use for the VPC public subnets"
  type        = list(string)
}

variable "vpc_private_subnet_cidrs" {
  description = "A list of CIDR blocks to use for the VPC private subnets"
  type        = list(string)
}

variable "vpc_database_subnet_cidrs" {
  description = "A list of CIDR blocks to use for the VPC database subnets"
  type        = list(string)
}

# EKS

variable "eks_node_instance_class" {
  description = "The EC2 instance class type of the nodes"
  type        = string
}

variable "eks_node_disk_size" {
  description = "The disk size of the nodes"
  type        = number
}

variable "eks_node_count_min" {
  description = "The minimum number of nodes"
  type        = number
}

variable "eks_node_count_max" {
  description = "The maximum number of nodes"
  type        = number
}

variable "eks_kubernetes_version" {
  description = "The version of Kubernetes to use for the EKS cluster"
  type        = string
}

variable "eks_aws_load_balancer_controller_version" {
  description = "Version of the AWS Load Balancer Controller to run"
  type        = string
}
