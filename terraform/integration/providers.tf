provider "aws" {
  region = "us-east-1"
}
terraform {
  backend "s3" {
    bucket         = "ngem-ops-artifacts-699300400344"
    key            = "ngem-api-prj/infra/terraform/dev/integration/producer-api/state/core.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "ngem-ops-infra-remote-state"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.19.0"
    }
  }
}
