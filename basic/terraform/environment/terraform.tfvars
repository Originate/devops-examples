# Root

account_id = "123456789012"
profile    = "mystack"
region     = "us-west-2"
stack      = "mystack"

# AWS

aws_base_domain                     = "mystack.originate.com"
aws_kms_key_deletion_window_in_days = 7

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

# EKS

eks_node_instance_class                  = "t3.medium"
eks_node_disk_size                       = 50
eks_node_count_min                       = 2
eks_node_count_max                       = 3
eks_kubernetes_version                   = "1.19"
eks_aws_load_balancer_controller_version = "1.1.5"

# RDS

rds_instance_class             = "db.t3.micro"
rds_allocated_storage          = 20
rds_multi_az                   = false
rds_backup_retention_period    = 7
rds_enable_enhanced_monitoring = false
rds_enable_delete_protection   = false
rds_skip_final_snapshot        = true

# Bastion

bastion_ssh_port = 62622
