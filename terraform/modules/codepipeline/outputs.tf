output "codepipeline_name" {
  description = "The name of the CodePipeline project"
  value       = aws_codepipeline.ngem_ops_app_codepipeline.name
}
