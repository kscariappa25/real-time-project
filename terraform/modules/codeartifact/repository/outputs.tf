output "codeartifact_repository_arn" {
  description = "AWS CodeBuild project name"
  value       = aws_codeartifact_repository.ngem_ops_python_repository.arn
}
