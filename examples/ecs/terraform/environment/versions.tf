terraform {
  required_version = "0.15.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.38.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
}
