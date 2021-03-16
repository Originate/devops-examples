module "rds" {
  source = "github.com/originate/terraform-modules/aws/rds"

  sql_database = "backend"
  attributes   = var.rds_attributes
}
