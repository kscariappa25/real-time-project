resource "aws_codebuild_project" "ngem_ops_infra_codebuild" {
  name          = var.codebuild_project_name
  description   = "CodeBuild project for cross-account infrastructure deployment"
  build_timeout = "60"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type      = "S3"
    location  = var.codebuild_artifacts_bucket_name
    packaging = "NONE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    dynamic "environment_variable" {
      for_each = var.codebuild_environment_variables
      content {
        name  = environment_variable.key
        value = environment_variable.value
      }
    }
  }

  source {
    type            = "GITHUB"
    location        = var.source_code_repo
    git_clone_depth = 1
    buildspec       = var.codebuild_buildspec_file_path
    auth {
      type     = "CODECONNECTIONS"
      resource = var.source_codeconnections_arn
    }
  }
}

resource "aws_codepipeline" "ngem_ops_app_codepipeline" {
  name          = "${var.codebuild_project_name}-pipeline"
  role_arn      = aws_iam_role.codebuild_role.arn
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
        ConnectionArn    = var.source_codeconnections_arn
        FullRepositoryId = "kscariappa25/real-time-project"
        BranchName       = var.default_branch
        DetectChanges    = "true"
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "TerraformDeploy"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      configuration = {
        ProjectName = aws_codebuild_project.ngem_ops_infra_codebuild.name
      }
    }
  }
}