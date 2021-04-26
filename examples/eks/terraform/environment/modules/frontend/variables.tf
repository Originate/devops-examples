variable "kubernetes_namespace" {
  description = "The namespace to deploy into"
  type        = string
}

variable "docker_repo" {
  description = "The repository of the Docker image to deploy"
  type        = string
}

variable "docker_tag" {
  description = "The tag of the Docker image to deploy"
  type        = string
}

variable "autoscale_max" {
  description = "Maximum number of instances per service"
  type        = number
}

variable "autoscale_min" {
  description = "Minimum number of instances per service"
  type        = number
}
