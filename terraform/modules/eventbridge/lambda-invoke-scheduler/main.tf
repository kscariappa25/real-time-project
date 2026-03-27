resource "aws_scheduler_schedule" "lambda_schedule" {
  name       = var.schedule_name
  group_name = var.schedule_group_name

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = var.schedule_expression

  target {
    arn      = var.target_lambda_arn
    role_arn = var.schedule_target_role_arn
  }
}
