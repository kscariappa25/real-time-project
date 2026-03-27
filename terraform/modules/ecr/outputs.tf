output "ecr_repo_arn" {
  description = "AWS ECR repo url"
  value       = aws_ecr_repository.ecr_repository.arn
}
