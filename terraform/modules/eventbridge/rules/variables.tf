variable "project_name" {
  type        = string
  description = "Project name"
}
variable "sns_topic_name" {
  type        = string
  description = "SNS topic name"
}
variable "eventrule_pipeline_name" {
  type        = string
  description = "CodePipeline name to watch"
}
variable "sns_subscribers_emails" {
  type        = list(string)
  description = "List of email addresses to notify"
  default     = []
}
