terraform {
  required_version = "0.14.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.28.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.0.0"
    }
  }
}
