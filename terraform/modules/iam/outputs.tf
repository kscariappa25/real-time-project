output "iam_role_arn" {
  value = aws_iam_role.iam_service_role.arn
}

output "iam_role_name" {
  value = aws_iam_role.iam_service_role.name
}