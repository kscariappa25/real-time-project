output "codecommit_repo_sns_topic_arn" {
  description = "AWS CodeCommit repo SNS topic trigger ARN."
  value = aws_sns_topic.codecommit_repo_sns_topic.arn
}
output "codecommit_repo_http_url" {
  description = "AWS CodeCommit repo HTTPS url"
  value       = aws_codecommit_repository.codecommit_repo.clone_url_http
}
