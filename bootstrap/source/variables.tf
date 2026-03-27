variable "repo_name" {
  type    = string
  default = "ngem-infra-core"
}
variable "default_branch" {
  type    = string
  default = "main"
}
variable "environment" {
  type = string
}
variable "codebuild_project_name" {
  type = string
}
variable "codebuild_environment_variables" {
  type = map(string)
  default = {
    "TERRAFORM_ACTION"              = "apply"
    "DESTINATION_ACCOUNT_id"        = ""
    "DESTINATION_ACCOUNT_ROLE_NAME" = ""
    "DESTINATION_PROJECT_NAME"      = ""
  }
}
variable "codebuild_buildspec_file_path" {
  type    = string
  default = "./buildspec_cross_account_dev.yml"
}
variable "codebuild_artifacts_bucket_name" {
  type    = string
  default = "ngem-ops-artifacts"
}
variable "codepipeline_type" {
  type    = string
  default = "V2"
}
variable "artifacts_bucket" {
  type    = string
  default = "ngem-ops-artifacts"
}
variable "codepipeline_owner" {
  type    = string
  default = "AWS"
}
variable "source_iam_role_name" {
  type        = string
  description = "Provide the cross account source name"
}
variable "destination_accountid" {
  type        = number
  description = "Provide the cross account Destination name"
}
variable "destination_role_name" {
  type        = string
  description = "Provide the cross account Destination name"
}
variable "cross_account_role_iam_policies" {
  type        = list(string)
  description = "Provide the list of required IAM policy List"
  default = [
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonRDSDataFullAccess",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy",
    "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSComputePolicy",
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]
}
variable "source_code_repo" {
  description = "Provide repo name"
  type        = string
}
variable "source_codeconnections_arn" {
  description = "Provide the connection arn for repo access"
  type        = string
}
variable "sandbox_dest_accountid" {
  type = string
}
variable "sandbox_dest_role_name" {
  type = string
}
