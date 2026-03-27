variable "codebuild_role_name" {
  type    = string
  default = "ngem-api-ops-codebuild-manager-role"
}
variable "codepipeline_role_name" {
  type    = string
  default = "ngem-api-ops-codepipeline-manager-role"
}
variable "development_aws_account_id" {
  type        = string
  description = "Development AWS account ID"
}
variable "development_account_iam_role" {
  type        = string
  description = "Cross-account role name in dev account"
}
variable "infra_backend_bucket" {
  type    = string
  default = "ngem-ops-infra"
}
variable "infra_dynamodb_table" {
  type    = string
  default = "ngem-ops-infra-remote-state"
}
variable "artifact_bucket" {
  type    = string
  default = "ngem-ops-artifacts"
}
