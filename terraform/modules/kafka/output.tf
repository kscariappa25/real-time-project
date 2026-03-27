output "arn" {
  description = "Amazon Resource Name (ARN) of the MSK cluster"
  value       = try(aws_msk_cluster.ngem_ops_msk_cluster.arn, null)
}
output "bootstrap_brokers" {
  description = "Comma separated list of bootstrap brokers"
  value = compact([
    try(aws_msk_cluster.ngem_ops_msk_cluster.bootstrap_brokers, null),
    try(aws_msk_cluster.ngem_ops_msk_cluster.bootstrap_brokers_sasl_iam, null),
    try(aws_msk_cluster.ngem_ops_msk_cluster.bootstrap_brokers_sasl_scram, null),
    try(aws_msk_cluster.ngem_ops_msk_cluster.bootstrap_brokers_tls, null),
  ])
}
output "bootstrap_brokers_sasl_iam" {
  description = "IAM SASL bootstrap brokers"
  value       = try(aws_msk_cluster.ngem_ops_msk_cluster.bootstrap_brokers_sasl_iam, null)
}
output "bootstrap_brokers_tls" {
  description = "TLS bootstrap brokers"
  value       = try(aws_msk_cluster.ngem_ops_msk_cluster.bootstrap_brokers_tls, null)
}
output "cluster_uuid" {
  description = "UUID of the MSK cluster"
  value       = try(aws_msk_cluster.ngem_ops_msk_cluster.cluster_uuid, null)
}
output "current_version" {
  description = "Current version of the MSK Cluster"
  value       = try(aws_msk_cluster.ngem_ops_msk_cluster.current_version, null)
}
output "security_groups" {
  value = try(aws_security_group.msk_cluster_security_group)
}
output "ngem_api_msk_cluster_details" {
  value = {
    vpc             = data.aws_vpc.ngem_ops_cluster_vpc.arn,
    subnet          = data.aws_subnets.ngem_ops_cluster_private_subnets.ids,
    cloudwatch_logs = aws_cloudwatch_log_group.ngem_ops_msk_log_group.arn,
    aws_s3_bucket   = aws_s3_bucket.ngem_ops_msk_broker_logs.arn,
    kafka_version   = aws_msk_configuration.ngem_ops_msk_config.kafka_versions,
    number_of_broker_nodes = aws_msk_cluster.ngem_ops_msk_cluster.broker_node_group_info,
    security_group  = aws_security_group.msk_cluster_security_group.id,
  }
}
