variable "aws_region" {
  default = "us-east-1"
}
variable "dynatrace_env_id" {
  description = "Your Dynatrace Environment ID (e.g., abc12345)"
  type        = string
}
variable "dynatrace_log_token" {
  description = "Dynatrace API Token with logs.ingest scope"
  type        = string
  sensitive   = true
}
