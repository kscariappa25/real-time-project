locals {
  github_connection_arn = "arn:aws:codeconnections:ap-south-1:699300400344:connection/9bf92c5d-944c-4fd1-ab9d-b0731c389d57"
}

module "app_ecr_repo" {
  source                     = "../modules/ecr"
  ecr_repo_name              = "${var.project_name}-container-repo"
  ecr_mutability_status      = "MUTABLE"
  destination_aws_account_id = var.destination_aws_account_id
  ecr_tags                   = { Project = var.project_name }
}

module "app_artifacts_bucket" {
  source                     = "../modules/s3"
  bucket_name = "${var.project_name}-dev-${data.aws_caller_identity.current.account_id}"
  region                     = "us-east-1"
  project_name               = var.project_name
  destination_aws_account_id = var.destination_aws_account_id
  source_aws_account_id      = data.aws_caller_identity.current.account_id
  bucket_tags                = { Project = var.project_name }
}

module "app_codebuild" {
  source                          = "../modules/codebuild"
  codebuild_project_name          = "${var.project_name}-build"
  codebuild_role_arn              = var.codebuild_role_arn
  codebuild_artifacts_bucket_name = module.app_artifacts_bucket.bucket_name
  source_code_repo                = var.source_code_repo
  source_codeconnections_arn      = local.github_connection_arn
  source_repo_branch              = "main"
  codebuild_buildspec_file_path   = var.codebuild_buildspec_file_path
  aws_account_id                  = data.aws_caller_identity.current.account_id
  region                          = "us-east-1"
  codebuild_environment_variables = {
    DESTINATION_AWS_ACCOUNT_ID = var.destination_aws_account_id
    ECR_REPO_NAME              = "${var.project_name}-container-repo"
    PROJECT_NAME               = var.project_name
  }
}

module "app_codepipeline" {
  source                           = "../modules/codepipeline"
  project_name                     = var.project_name
  region                           = "us-east-1"
  aws_account_id                   = data.aws_caller_identity.current.account_id
  source_repo                      = var.repo_parent_project_name
  repo_parent_project_name         = var.repo_parent_project_name
  artifacts_bucket                 = module.app_artifacts_bucket.bucket_name
  custom_kms_key                   = var.custom_kms_key
  codepipeline_role_arn            = var.codepipeline_role_arn
  codebuild_project_name           = module.app_codebuild.codebuild_project_name
  codecommit_branch_name           = "main"
  codepipeline_type                = "V2"
  codepipeline_code_connection_arn = local.github_connection_arn
  ecs_cluster_name                 = var.ecs_cluster_name
  destination_aws_account_id       = var.destination_aws_account_id
  iam_codedeploy_arn               = "ngem-api-ops-dest-cross-account-dev-role"
  deploy_api_count                 = var.deploy_api_count
  deploy_actions                   = slice(var.deploy_actions, 0, var.deploy_api_count)
}

data "aws_caller_identity" "current" {}