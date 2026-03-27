data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "codebuild_extended_permissions_policy" {
  name        = "${var.codebuild_role_name}-extended-policy"
  description = "Extended permissions for CodeBuild"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "codecommit:*", "s3:*", "ecr:*", "logs:*", "codebuild:*",
          "dynamodb:*", "ssm:*", "sns:*", "sts:AssumeRole",
          "eks:Describe*", "codepipeline:*", "secretsmanager:*",
          "iam:PassRole", "events:*",
          "codeconnections:UseConnection",
          "codestar-connections:UseConnection"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "codeconnections:UseConnection",
          "codestar-connections:UseConnection"
        ]
        Resource = "arn:aws:codeconnections:ap-south-1:699300400344:connection/9bf92c5d-944c-4fd1-ab9d-b0731c389d57"
      }
    ]
  })
}

resource "aws_iam_policy" "codepipeline_extended_permissions_policy" {
  name        = "${var.codepipeline_role_name}-extended-policy"
  description = "Extended permissions for CodePipeline"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*",
          "ecr:*",
          "codebuild:*",
          "kms:*",
          "logs:*",
          "codeconnections:UseConnection",
          "codestar-connections:UseConnection",
          "iam:PassRole",
          "sts:AssumeRole",
          "ecs:*",
          "elasticloadbalancing:*"
        ]
        Resource = "*"
      }
    ]
  })
}

module "codebuild_iam_role" {
  source                      = "../modules/iam"
  role_name                   = var.codebuild_role_name
  assume_services             = ["codebuild.amazonaws.com"]
  iam_service_role_policy_arn = aws_iam_policy.codebuild_extended_permissions_policy.arn
}

module "codepipeline_iam_role" {
  source                      = "../modules/iam"
  role_name                   = var.codepipeline_role_name
  assume_services             = ["codepipeline.amazonaws.com"]
  iam_service_role_policy_arn = aws_iam_policy.codepipeline_extended_permissions_policy.arn
}

resource "aws_iam_role_policy_attachment" "codebuild_admin" {
  role       = module.codebuild_iam_role.iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess"
}

resource "aws_ssm_parameter" "backend_bucket" {
  name  = "/ngem-api/infra/backend/bucket"
  type  = "String"
  value = var.infra_backend_bucket
}

resource "aws_ssm_parameter" "backend_dynamodb" {
  name  = "/ngem-api/infra/backend/dynamodb_table"
  type  = "String"
  value = var.infra_dynamodb_table
}