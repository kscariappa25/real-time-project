output "ngem_api_msk_multi_vpc" {
  value = {
    authentication = aws_msk_vpc_connection.multi-vpc-enabled.authentication,
    target_cluster_arn = aws_msk_vpc_connection.multi-vpc-enabled.target_cluster_arn
    security_groups = aws_msk_vpc_connection.multi-vpc-enabled.security_groups
  }
}
