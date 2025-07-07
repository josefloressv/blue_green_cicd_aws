terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.68.0" # M1 crashes with 5.69 and above
    }
  }
}