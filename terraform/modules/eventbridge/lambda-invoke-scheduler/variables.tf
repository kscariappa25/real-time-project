variable "schedule_name" {
  type        = string
  description = "Name of the EventBridge schedule"
}
variable "schedule_group_name" {
  type        = string
  description = "Schedule group name"
  default     = "default"
}
variable "target_lambda_arn" {
  type        = string
  description = "ARN of the Lambda function to invoke"
}
variable "schedule_target_role_arn" {
  type        = string
  description = "IAM role ARN for the scheduler to assume"
}
variable "schedule_expression" {
  type        = string
  description = "Schedule expression e.g. rate(5 minutes) or cron(0 12 * * ? *)"
}
