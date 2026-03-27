variable "lambda_function_name" {
  description = "AWS lambda function name"
  type        = string
}
variable "lambda_execution_role_arn" {
  description = "AWS lambda execution role ARN"
  type        = string
}
variable "lambda_image_uri" {
  description   = "AWS Lambda container image URI"
  type          = string
}
variable "lambda_tags" {
  description   = "AWS Lambda tags"
  type          = map(string)
}
variable "lambda_timeout" {
  description   = "AWS Lambda timeout"
  type          = string
}
