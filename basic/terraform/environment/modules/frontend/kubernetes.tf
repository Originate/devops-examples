locals {
  container_port    = 8080
  health_check_path = "/"
}

module "kubernetes" {
  source = "github.com/Originate/terraform-modules//kubernetes/application?ref=d679df0"

  name                 = "frontend"
  kubernetes_namespace = var.kubernetes_namespace
  docker_repo          = var.docker_repo
  docker_tag           = var.docker_tag
  container_port       = local.container_port
  health_check_path    = local.health_check_path
  run_as_user          = 101 # nginx
  run_as_group         = 101 # nginx
  autoscale_max        = var.autoscale_max
  autoscale_min        = var.autoscale_min
  using_eks            = true

  ephemeral_mount_paths = {
    cache = "/var/cache/nginx"
    pid   = "/var/run"
  }
}
