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

# RDS

variable "rds_instance_class" {
  description = "The RDS instance class type"
  type        = string
}

variable "rds_allocated_storage" {
  description = "The allocated storage for RDS instances in gibibytes"
  type        = number

  validation {
    condition     = var.rds_allocated_storage >= 20 && var.rds_allocated_storage <= 65536
    error_message = "The rds_allocated_storage value must be between 20 and 65,536 GiB, inclusive."
  }
}

variable "rds_multi_az" {
  description = "Specifies if RDS instances are multi-AZ"
  type        = bool
}

variable "rds_backup_retention_period" {
  description = "The number of days to retain RDS backups"
  type        = number

  validation {
    condition     = var.rds_backup_retention_period >= 0 && var.rds_backup_retention_period <= 35
    error_message = "The rds_backup_retention_period value must be between 0 and 35 days, inclusive."
  }
}

variable "rds_enable_enhanced_monitoring" {
  description = "Enable RDS Enhanced Monitoring metrics"
  type        = bool
}

variable "rds_enable_delete_protection" {
  description = "Disable deletion of RDS instances"
  type        = bool
}

variable "rds_skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before RDS instances are deleted"
  type        = bool
}

# ECS Stack

variable "build_updated_docker_images" {
  description = "Locally build and push new images when overriding Docker tags"
  type        = bool
}

variable "override_docker_tags" {
  description = "Override this value to update the Docker image tag for specific components (takes priority over var.universal_docker_tag)"
  type = object(
    {
      # Key names must match the name of the repository
      backend  = optional(string)
      frontend = optional(string)
    }
  )
  default = {}
}

# Convenient shortcut for overriding all tags at once without needing to specify
# each of them individually through var.override_docker_tags
variable "universal_override_docker_tag" {
  description = "Override this value to update the Docker image tag for all components that do not have a specific value provided in var.override_docker_tags"
  type        = string
  default     = ""
}

variable "additional_docker_tags" {
  description = "Additional tags to add to Docker images when overriding Docker tags"
  type        = list(string)
  default     = []
}
