output "secrets" {
  value     = local.secrets
  sensitive = true
}

output "last_deployed_docker_tags" {
  value = local.docker_tags
}
