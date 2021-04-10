terraform {
  backend "s3" {
    workspace_key_prefix = "environment"
    key                  = "terraform.tfstate"
  }

  experiments = [module_variable_optional_attrs]
}

locals {
  # Disallow use of the default workspace
  check_default_workspace = terraform.workspace == "default" ? error("default workspace not allowed") : null

  # Stores secrets that can be managed in Terraform during an apply by passing
  # var.append_secrets or var.remove_secrets. If a key is passed in
  # var.append_secrets that is already present, it will overwrite the existing
  # value. If a key is present in both var.remove_secrets and
  # var.append_secrets, it will add the secret and the removal has no effect.
  secrets = merge(
    {
      for key, value in try(data.terraform_remote_state.self.outputs.secrets, {}) :
      key => value if !contains(var.remove_secrets, key)
    },
    var.append_secrets
  )
}
