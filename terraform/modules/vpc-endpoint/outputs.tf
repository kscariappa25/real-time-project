output "endpoint_id" {
  value = aws_vpc_endpoint.msk_endpoint.id
}

output "endpoint_dns" {
  value = aws_vpc_endpoint.msk_endpoint.dns_entry
}
