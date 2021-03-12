# Root

account_id = "123456789012"
profile    = "mystack"
region     = "us-west-2"
stack      = "mystack"

# AWS

aws_base_domain = "mystack.originate.com"

# VPC

vpc_az_count = 2
vpc_cidr     = "172.31.0.0/16"
vpc_public_subnet_cidrs = [
  "172.31.0.0/20",
  "172.31.16.0/20"
]
vpc_private_subnet_cidrs = [
  "172.31.32.0/20",
  "172.31.48.0/20"
]
vpc_database_subnet_cidrs = [
  "172.31.64.0/20",
  "172.31.80.0/20"
]
