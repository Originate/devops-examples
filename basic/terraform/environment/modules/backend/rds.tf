module "rds" {
  source = "github.com/Originate/terraform-modules//aws/rds?ref=e33985e"

  sql_database = "backend"
  attributes   = var.rds_attributes
}
