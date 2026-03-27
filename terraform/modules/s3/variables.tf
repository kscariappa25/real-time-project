variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "bucket_tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
}

variable "project_name" {
  type = string
}

variable "destination_aws_account_id" {
  type = string
}

variable "source_aws_account_id" {
  type        = string
  description = "Source AWS account ID where CodePipeline and CodeBuild run"
}