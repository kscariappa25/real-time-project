resource "aws_sns_topic" "pipeline_notifications" {
  name = var.sns_topic_name
}

resource "aws_ssm_parameter" "sns_subscribers" {
  name  = "/${var.project_name}/sns/subscribers"
  type  = "StringList"
  value = join(",", var.sns_subscribers_emails)
}

resource "aws_sns_topic_subscription" "email_subscriptions" {
  for_each  = toset(var.sns_subscribers_emails)
  topic_arn = aws_sns_topic.pipeline_notifications.arn
  protocol  = "email"
  endpoint  = each.value
}

resource "aws_cloudwatch_event_rule" "pipeline_state_change" {
  name        = "${var.project_name}-pipeline-state-change"
  description = "Capture CodePipeline state changes"
  event_pattern = jsonencode({
    source      = ["aws.codepipeline"]
    detail-type = ["CodePipeline Pipeline Execution State Change"]
    detail = {
      pipeline = [var.eventrule_pipeline_name]
    }
  })
}

resource "aws_cloudwatch_event_target" "sns_target" {
  rule      = aws_cloudwatch_event_rule.pipeline_state_change.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.pipeline_notifications.arn
}

resource "aws_sns_topic_policy" "allow_eventbridge" {
  arn = aws_sns_topic.pipeline_notifications.arn
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "events.amazonaws.com" }
      Action    = "sns:Publish"
      Resource  = aws_sns_topic.pipeline_notifications.arn
    }]
  })
}
