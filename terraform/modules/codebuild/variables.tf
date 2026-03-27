variable "codebuild_project_name" {
  type        = string
  description = "CodeBuild project name"
}
variable "project_description" {
  type        = string
  description = "CodeBuild project description"
  default     = "CodeBuild project for application deployment"
}
variable "codebuild_role_arn" {
  type        = string
  description = "IAM role ARN for CodeBuild"
}
variable "codebuild_artifacts_bucket_name" {
  type        = string
  description = "S3 bucket for CodeBuild artifacts"
}
variable "source_code_repo" {
  type        = string
  description = "Bitbucket repository URL"
}
variable "source_codeconnections_arn" {
  type        = string
  description = "CodeConnections ARN for Bitbucket"
}
variable "source_repo_branch" {
  type        = string
  description = "Branch to trigger builds on"
  default     = "main"
}
variable "codebuild_buildspec_file_path" {
  type        = string
  description = "Path to buildspec file in the repo"
  default     = "buildspec.yml"
}
variable "ecr_repo_name" {
  type        = string
  description = "ECR repository name"
  default     = ""
}
variable "aws_account_id" {
  type        = string
  description = "AWS Account ID"
}
variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}
variable "security_group_ids" {
  type        = list(string)
  description = "Security group IDs for CodeBuild VPC config"
  default     = []
}
variable "codebuild_environment_variables" {
  type        = map(string)
  description = "Environment variables for CodeBuild"
  default     = {}
}
