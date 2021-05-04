module "rds" {
  source = "github.com/Originate/terraform-modules//aws/rds?ref=v1"

  sql_database = "backend"
  attributes = merge(
    var.rds_attributes,
    {
      allowed_security_group_ids = [
        module.ecs_application.security_group_id,
        var.bastion_security_group_id
      ]
    }
  )
}
