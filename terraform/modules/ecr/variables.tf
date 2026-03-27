variable "ecr_repo_name" {
  description = "AWS ECR service repository name"
  type        = string
}
variable "ecr_mutability_status" {
  description = "AWS ECR Mutable status"
  type        = string
  default     = "MUTABLE"
}
variable ecr_tags {
  description = "AWS ECR Tags"
  type        = map(string)
}
variable "destination_aws_account_id" {
  type = number
  description = "Provide the Development aws account ID"
}
