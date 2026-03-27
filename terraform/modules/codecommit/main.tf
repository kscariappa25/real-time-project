resource "aws_sns_topic" "codecommit_sns_topic" {
  name = var.sns_topic_name
}

resource "aws_codecommit_repository" "ngem_ops_app_codecommit" {
  repository_name = var.repo_name
  description     = var.repo_description
  default_branch  = var.default_branch
  tags            = var.codecommit_tags
}

resource "aws_codecommit_trigger" "ngem_ops_app_codecommit_trigger" {
  repository_name = aws_codecommit_repository.ngem_ops_app_codecommit.repository_name
  trigger {
    name            = "${var.repo_name}-trigger"
    events          = ["all"]
    destination_arn = aws_sns_topic.codecommit_sns_topic.arn
  }
}
