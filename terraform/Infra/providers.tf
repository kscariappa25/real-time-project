provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "sanbox_account"
  region = "us-west-2"
  assume_role {
    role_arn = "arn:aws:iam::626635426805:role/ngem-api-ops-dest-cross-account-sandbox-role"
  }
}

provider "aws" {
  alias  = "development_account"
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::348542648035:role/ngem-api-ops-dest-cross-account-dev-role"
  }
}

provider "aws" {
  alias  = "development_account_us-west-2"
  region = "us-west-2"
  assume_role {
    role_arn = "arn:aws:iam::348542648035:role/ngem-api-ops-dest-cross-account-dev-role"
  }
}

terraform {
  backend "s3" {
    bucket         = "ngem-ops-artifacts-699300400344"
    key            = "ngem-api-prj/infra/terraform/dev/ngem-api-ops-infra-deployment/state/core.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "ngem-ops-infra-remote-state"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.20.0"
    }
  }
}