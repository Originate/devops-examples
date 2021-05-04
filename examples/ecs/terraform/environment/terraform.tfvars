# Root

account_id = "889376510746"
profile    = "ecsstack"
region     = "us-west-2"
stack      = "ecsstack"

# AWS

aws_base_domain                     = "ecsstack.originate.com"
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

# RDS

rds_instance_class             = "db.t3.micro"
rds_allocated_storage          = 20
rds_multi_az                   = false
rds_backup_retention_period    = 7
rds_enable_enhanced_monitoring = false
rds_enable_delete_protection   = false
rds_skip_final_snapshot        = true
