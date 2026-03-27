variable "cluster_arn" {
  description = "Provide the AWS MSK Cluster ARN"
}

variable "aws_msk_multi_connection_sg" {
  description = "MSK multi vpc sg"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the multi-vpc connection"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for the multi-vpc connection"
}

variable "development_account_vpc_cidr_blocks" {
  type        = list(string)
  description = "Development account VPC CIDR blocks"
  default     = ["10.0.0.0/16"]
}