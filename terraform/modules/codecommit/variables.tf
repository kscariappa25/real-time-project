variable "sns_topic_name" {
  type        = string
  description = "SNS topic name for CodeCommit notifications"
}
variable "repo_name" {
  type        = string
  description = "CodeCommit repository name"
}
variable "repo_description" {
  type        = string
  description = "CodeCommit repository description"
  default     = ""
}
variable "default_branch" {
  type        = string
  description = "Default branch name"
  default     = "main"
}
variable "codecommit_tags" {
  type        = map(string)
  description = "Tags for the CodeCommit repository"
  default     = {}
}
