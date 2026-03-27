provider "aws" {
  region = "us-east-1"
  profile = "kirtan"
}

terraform {
  backend "s3" {
    bucket         = "ngem-ops-infra-test"
    key            = "ngem-api-prj/infra/terraform/dev/bootstrap/source_account_iam_role.tfstate"
    region         = "us-east-1"
    encrypt        = true
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