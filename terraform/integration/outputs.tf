output "codebuild_project_arn"  { value = module.app_codebuild.codebuild_project_arn }
output "ecr_app_repo_arn"       { value = module.app_ecr_repo.ecr_repo_arn }
output "codepipeline_name"      { value = module.app_codepipeline.codepipeline_name }
