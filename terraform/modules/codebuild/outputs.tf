output "codebuild_project_arn" {
  description = "AWS CodeBuild project ARN"
  value       = aws_codebuild_project.ngem_ops_app_codebuild.arn
}

output "codebuild_project_name" {
  description = "AWS CodeBuild project name"
  value       = aws_codebuild_project.ngem_ops_app_codebuild.name
}