locals {
  # Defines a map for easily passing environment default variable arguments to
  # the github.com/Originate/terraform-modules//aws/rds module. Individual
  # modules can override values by individually reassigning them or using the
  # Terraform merge() function.
  rds_attributes = {
    stack                      = var.stack
    env                        = terraform.workspace
    default_tags               = local.default_tags
    vpc_id                     = module.vpc.id
    subnet_ids                 = module.vpc.database_subnet_ids
    allowed_security_group_ids = [module.eks.cluster_security_group_id]
    instance_class             = var.rds_instance_class
    allocated_storage          = var.rds_allocated_storage
    multi_az                   = var.rds_multi_az
    backup_retention_period    = var.rds_backup_retention_period
    enable_enhanced_monitoring = var.rds_enable_enhanced_monitoring
    enable_delete_protection   = var.rds_enable_delete_protection
    skip_final_snapshot        = var.rds_skip_final_snapshot
  }
}
