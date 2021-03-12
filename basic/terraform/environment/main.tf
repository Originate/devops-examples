terraform {
  backend "s3" {
    workspace_key_prefix = "environment"
    key                  = "terraform.tfstate"
  }
}

locals {
  # Disallow use of the default workspace
  check_default_workspace = terraform.workspace == "default" ? error("default workspace not allowed") : null
}
