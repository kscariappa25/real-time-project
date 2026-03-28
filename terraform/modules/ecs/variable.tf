variable "cluster_name" {
  type        = string
  description = "ECS Cluster name"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g. dev, prod)"
}

variable "tags" {
  type        = map(string)
  description = "Tags for all resources"
  default     = {}
}

variable "private_subnet_tag_key_name" {
  type    = string
  default = "type"
}

variable "private_subnet_tag_value_name" {
  type    = string
  default = "private"
}

variable "public_subnet_tag_key_name" {
  type    = string
  default = "type"
}

variable "public_subnet_tag_value_name" {
  type    = string
  default = "public"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "certificate_id" {
  type    = string
  default = ""
  description = "ACM Certificate UUID — leave empty to skip HTTPS listener"
}

variable "destination_account_id" {
  type = string
}

variable "source_account_id" {
  type = number
}

variable "producer_container_repo_name" {
  type    = string
  default = ""
}

variable "consumer_container_repo_name" {
  type    = string
  default = ""
}

variable "image_tag" {
  type    = string
  default = "latest"
}

variable "dt_aws_account_id" {
  type    = string
  default = ""
}

variable "dt_kms_aws_account_id" {
  type    = string
  default = ""
}

variable "otel_container_repo_name" {
  type    = string
  default = ""
}

variable "sandbox_aws_account_id" {
  type = string
}

variable "eks_cluster_security_group_id" {
  type    = string
  default = ""
}

variable "ec2_security_group_id" {
  type    = string
  default = ""
}
