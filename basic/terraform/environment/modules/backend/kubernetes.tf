locals {
  container_port    = 3000
  health_check_path = "/"
}

module "kubernetes" {
  source = "github.com/originate/terraform-modules/custom/kubernetes_service"

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
      DB_HOST     = module.rds.host
      DB_PORT     = module.rds.port
      DB_NAME     = module.rds.database
      DB_USERNAME = module.rds.username
      DB_PASSWORD = module.rds.password
    }
  }
}
