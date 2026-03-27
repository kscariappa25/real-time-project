provider "aws" {
  region  = "us-east-1"
  profile = "Citius"
}

terraform {
  backend "s3" {
    bucket       = "ngem-ops-infra-test"
    key          = "ngem-api-prj/infra/terraform/ci-cd-core-infra/state/ngem-api-infra-core-poc.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
    profile      = "kirtan"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}