variable "region" {
    description = "Kafka Cluster AWS region"
    type        = string
    default = "us-east-1"
}
variable "msk_cluster_name" {
    type    = string
    description = "AWS MSK cluster description."
    default = "ngem-api-ops-msk-dev-cluster"
}
variable "msk_cluster_kafka_version" {
    type    = string
    description = "AWS MSK cluster kafka version."
    default = ""
}
variable "msk_cluster_instance_type" {
    type        = string
    description = "Cluster EC2 server type."
    default = "kafka.m5.large"
}
variable "msk_cluster_ebs_storage_volume_size" {
    type        = string
    description = "Cluster EBS Storage volume size."
    default = "100"
}
variable "number_of_broker_nodes" {
    description = "AWS MSK cluster number_of_broker_nodes"
    default = "3"
}
variable "tags" {
  type = map(string)
}
variable "aws_client_account_id" {
  description = "Provide the AWS Client Account ID"
}
variable "env" {
  description = "Provide the Env Name"
}
variable "private_subnet_tag_key_name" {
  type        = string
  description = "Provide the private_subnet_tag_key_name from the subnet tags"
}
variable "private_subnet_tag_value_name" {
  type        = string
  description = "Provide the private_subnet_tag_value_name from the subnet tags"
}
variable "public_subnet_tag_key_name" {
  type        = string
  description = "Provide the public_subnet_tag_key_name from the subnet tags"
}
variable "public_subnet_tag_value_name" {
  type        = string
  description = "Provide the public_subnet_tag_value_name from the subnet tags"
}
