module "rds" {
  source = "github.com/Originate/terraform-modules//aws/rds?ref=0a5d76f"

  sql_database = "backend"
  attributes   = var.rds_attributes
}
