module "rds" {
  source = "github.com/Originate/terraform-modules//aws/rds?ref=c50291f"

  sql_database = "backend"
  attributes   = var.rds_attributes
}
