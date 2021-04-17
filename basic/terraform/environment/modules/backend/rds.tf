module "rds" {
  source = "github.com/Originate/terraform-modules//aws/rds?ref=d679df0"

  sql_database = "backend"
  attributes   = var.rds_attributes
}
