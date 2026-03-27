output "aws_lambda_arn" {
  description = "AWS lambda ARN"
  value       = aws_lambda_function.aws_lambda.arn
}
