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
