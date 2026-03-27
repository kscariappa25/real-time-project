# SOURCE account — default provider (us-east-1)
provider "aws" {
  region  = "us-east-1"
  profile = "kirtan"
}

# SANDBOX account — Kafka + Glue (us-west-2)
provider "aws" {
  alias   = "sanbox_account"
  region  = "us-west-2"
  profile = "kirtan"
  assume_role {
    role_arn = "arn:aws:iam::626635426805:role/ngem-api-ops-dest-cross-account-sandbox-role"
  }
}

# DEV account — ECS + ALB + Firehose (us-east-1)
provider "aws" {
  alias   = "development_account"
  region  = "us-east-1"
  profile = "kirtan"
  assume_role {
    role_arn = "arn:aws:iam::348542648035:role/ngem-api-ops-dest-cross-account-dev-role"
  }
}

# DEV account — Multi-VPC bridge (us-west-2)
provider "aws" {
  alias   = "development_account_us-west-2"
  region  = "us-west-2"
  profile = "kirtan"
  assume_role {
    role_arn = "arn:aws:iam::348542648035:role/ngem-api-ops-dest-cross-account-dev-role"
  }
}

terraform {
  backend "s3" {
    bucket       = "ngem-ops-infra-test"
    key          = "ngem-api-prj/infra/terraform/dev/ngem-api-ops-infra-deployment/state/core.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
    profile      = "kirtan"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.20.0"
    }
  }
}