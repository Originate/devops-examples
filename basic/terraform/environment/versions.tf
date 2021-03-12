terraform {
  required_version = "0.14.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.32.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.0.3"
    }
    http = {
      source  = "hashicorp/http"
      version = "2.1.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.10.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.0.2"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.7.0"
    }
  }
}
