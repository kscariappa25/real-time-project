provider "aws" {
  region  = "us-east-1"
  profile = "kirtan"
}
terraform {
  backend "s3" {
    bucket       = "ngem-ops-infra-test"
    key          = "ngem-api-prj/infra/terraform/dev/integration/producer-api/state/core.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
    profile      = "kirtan"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.19.0"
    }
  }
}