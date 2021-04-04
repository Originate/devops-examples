locals {
  container_port    = 3000
  health_check_path = "/api/healthcheck"
}

module "kubernetes" {
  source = "github.com/Originate/terraform-modules//kubernetes/application?ref=0a5d76f"

  name                 = "backend"
  kubernetes_namespace = var.kubernetes_namespace
  docker_repo          = var.docker_repo
  docker_tag           = var.docker_tag
  container_port       = local.container_port
  health_check_path    = local.health_check_path
  autoscale_max        = var.autoscale_max
  autoscale_min        = var.autoscale_min
  using_eks            = true

  ephemeral_mount_paths = {
    yarn  = "/usr/local/share/.yarn"
    cache = "/usr/local/share/.cache"
    tmp   = "/tmp"
  }

  config_maps = {
    env = {
      PORT = local.container_port
    }
  }

  secrets = {
    db-config = {
      PGHOST     = module.rds.host
      PGPORT     = module.rds.port
      PGDATABASE = module.rds.database
      PGUSER     = module.rds.username
      PGPASSWORD = module.rds.password
      PGSSLMODE  = "no-verify"
    }
  }
}
