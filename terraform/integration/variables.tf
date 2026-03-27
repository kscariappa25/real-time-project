variable "project_name" {
  type        = string
  description = "Project/service name — used for naming all resources"
}
variable "destination_aws_account_id" {
  type        = string
  description = "Dev account ID where ECS lives"
}
variable "codebuild_role_arn" {
  type    = string
  default = "arn:aws:iam::ACCOUNT_ID:role/ngem-api-ops-codebuild-manager-role"
}
variable "codepipeline_role_arn" {
  type    = string
  default = "arn:aws:iam::ACCOUNT_ID:role/ngem-api-ops-codepipeline-manager-role"
}
variable "codebuild_buildspec_file_path" {
  type    = string
  default = "buildspec.yml"
}
variable "source_code_repo" {
  type    = string
  default = ""
}
variable "repo_parent_project_name" {
  type    = string
  default = ""
}
variable "ecs_cluster_name" {
  type    = string
  default = "ngem-api-dev-ecs-cluster"
}
variable "service_name" {
  type    = string
  default = ""
}
variable "custom_kms_key" {
  type    = string
  default = ""
}
variable "deploy_api_count" {
  type    = number
  default = 1
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

variable "env" {
  description = "Environment name (dev, stage, prod)"
  type        = string
}