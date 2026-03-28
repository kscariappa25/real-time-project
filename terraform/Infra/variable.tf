variable "msk_cluster_name" {
  type = string
}
variable "msk_cluster_kafka_version" {
  type = string
}
variable "msk_cluster_ebs_storage_volume_size" {
  type = string
}
variable "number_of_broker_nodes" {
  type = string
}
variable "msk_cluster_instance_type" {
  type = string
}
variable "msk_deploy_region" {
  type    = string
  default = "us-west-2"
}
variable "env" {
  type    = string
  default = "dev"
}
variable "cluster_name" {
  type = string
}
variable "environment" {
  type    = string
  default = "dev"
}
variable "region" {
  type    = string
  default = "us-east-1"
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
variable "certificate_id" {
  type    = string
  default = ""
}
variable "destination_account_id" {
  type = string
}
variable "development_aws_account_id" {
  type = string
}
variable "source_account_id" {
  type = string
}
variable "sandbox_aws_account_id" {
  type = string
}
variable "dt_aws_account_id" {
  type    = string
  default = ""
}
variable "dt_kms_aws_account_id" {
  type    = string
  default = ""
}
variable "dynatrace_env_id" {
  type    = string
  default = ""
}
variable "dynatrace_log_token" {
  type      = string
  default   = ""
  sensitive = true
}
variable "eks_cluster_security_group_id" {
  type    = string
  default = ""
}
variable "ec2_security_group_id" {
  type    = string
  default = ""
}
variable "global_tags" {
  type = map(string)
  default = {
    "nextgen.environment" = "dev"
    "nextgen.project"     = "NGEAPI"
    "nextgen.automation"  = "true"
  }
}

variable "sandbox_vpc_id" {
  type        = string
  description = "VPC ID in SANDBOX account"
}

variable "sandbox_private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs in SANDBOX account"
}

variable "msk_broker_ips_ports" {
  type = list(object({
    ip   = string
    port = string
  }))
  description = "MSK broker IPs and ports"
}