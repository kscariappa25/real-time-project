variable "api_name" {
  type        = string
  description = "ECS Cluster name"
}
variable "private_subnet_tag_key_name" {
  type        = string
}
variable "private_subnet_tag_value_name" {
  type        = string
}
variable "public_subnet_tag_key_name" {
  type        = string
}
variable "public_subnet_tag_value_name" {
  type        = string
}
variable "region" {
  type = string
}
variable "destination_account_id" {
  type = number
}
variable "source_account_id" {
  type = number
}
variable "container_repo_name" {
  type = string
}
variable "image_tag" {
  type = string
}
variable "ngem_api_ecs_cluster_id" {
  type = string
}
variable "security_group" {
  type = string
}
variable "cloud_watch_group" {
  type = string
}
variable "health_check_path" {
  type = string
}
variable "listener_arn" {
  type = string
}
variable "path_pattern" {
  type = string
}
variable "priority" {
  type = number
}
variable "container_name" {
  type = string
}
variable "container_cpu" {
  type = number
}
variable "container_memory" {
  type = number
}
variable "dt_kms_aws_account_id" {
  type = number
}
variable "dt_aws_account_id" {
  type = number
}
