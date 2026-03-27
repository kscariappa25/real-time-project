variable "project_name" {
  type        = string
  description = "Project name used for pipeline naming"
}
variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}
variable "aws_account_id" {
  type        = string
  description = "Source AWS account ID"
}
variable "source_repo" {
  type        = string
  description = "Bitbucket source repo URL"
}
variable "repo_parent_project_name" {
  type        = string
  description = "Bitbucket workspace/project name"
}
variable "artifacts_bucket" {
  type        = string
  description = "S3 bucket for pipeline artifacts"
}
variable "custom_kms_key" {
  type        = string
  description = "KMS key UUID for artifact encryption"
}
variable "codepipeline_role_arn" {
  type        = string
  description = "IAM role ARN for CodePipeline"
}
variable "codebuild_project_name" {
  type        = string
  description = "CodeBuild project name"
}
variable "codecommit_branch_name" {
  type        = string
  description = "Branch to trigger pipeline on"
  default     = "main"
}
variable "codepipeline_type" {
  type        = string
  description = "Pipeline type (V1 or V2)"
  default     = "V2"
}
variable "codepipeline_code_connection_arn" {
  type        = string
  description = "CodeConnections ARN for Bitbucket"
}
variable "ecs_cluster_name" {
  type        = string
  description = "ECS cluster name to deploy to"
}
variable "destination_aws_account_id" {
  type        = string
  description = "Destination AWS account ID"
}
variable "iam_codedeploy_arn" {
  type        = string
  description = "Cross-account deploy role name"
}
variable "deploy_actions" {
  type = list(object({
    name         = string
    service_name = string
    file_name    = string
  }))
  default = [
    { name = "Deploy-Primary",   service_name = "ngem-api-dev-ecs-cluster-prd-srv", file_name = "producer-imagedefinitions.json" },
    { name = "Deploy-Secondary", service_name = "ngem-api-dev-ecs-cluster-con-svc", file_name = "consumer-imagedefinitions.json" }
  ]
}
variable "deploy_api_count" {
  type        = number
  description = "Number of deploy actions to use"
  default     = 1
}
