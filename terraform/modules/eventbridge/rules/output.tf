output "sns_subscribers_emails" {
  value = aws_ssm_parameter.sns_subscription_endpoint.name
}
