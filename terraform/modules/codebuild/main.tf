resource "aws_codebuild_project" "ngem_ops_app_codebuild" {
  name          = var.codebuild_project_name
  description   = var.project_description
  build_timeout = "30"
  service_role  = var.codebuild_role_arn

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
    privileged_mode             = true

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

  logs_config {
    cloudwatch_logs {
      group_name = "/aws/codebuild/${var.codebuild_project_name}"
    }
  }
}