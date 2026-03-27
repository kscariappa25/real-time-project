variable "source_aws_accountid" {
  description = "Provide the AWS Account ID"
  type        = string
}
variable "source_aws_role_name" {
  description = "Provide the IAM Role Name"
  type        = string
}
variable "destination_cross_account_name" {
  description = "Provide the AWS Account Name"
  type        = string
}
variable "cross_account_role_iam_policies" {
  type        = list(string)
  description = "Provide the list of required IAM policy List"
  default = [
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AdministratorAccess",
    "arn:aws:iam::aws:policy/AmazonRDSDataFullAccess",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess"
  ]
}
variable "source_dynamodb_table_name" {
  type = string
}
variable "source_code_aws_role_name" {
  type = string
}
variable "region" {
  type = string
  default = "us-east-1"
}
variable "source_account_kms_id" {
  type = string
}
variable "source_account_producer_s3_bucket_name" {
  type = string
}
