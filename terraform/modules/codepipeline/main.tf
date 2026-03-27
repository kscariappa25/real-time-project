resource "aws_codepipeline" "ngem_ops_app_codepipeline" {
  name          = "${var.project_name}-pipeline"
  role_arn      = var.codepipeline_role_arn
  pipeline_type = var.codepipeline_type

  artifact_store {
    location = var.artifacts_bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        ConnectionArn        = var.codepipeline_code_connection_arn
        FullRepositoryId     = var.source_repo
        BranchName           = var.codecommit_branch_name
        DetectChanges        = true
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      configuration = {
        ProjectName = var.codebuild_project_name
      }
    }
  }
}