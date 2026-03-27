output "endpoint_service_name" {
  value = aws_vpc_endpoint_service.msk_endpoint_service.service_name
}

output "nlb_arn" {
  value = aws_lb.msk_nlb.arn
}
