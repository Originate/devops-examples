module "rds" {
  source = "github.com/Originate/terraform-modules//aws/rds?ref=v1"

  sql_database = "backend"
  attributes   = var.rds_attributes
}
