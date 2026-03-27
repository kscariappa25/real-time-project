# Fetch the actual Dynatrace log ingest token value from Secrets Manager
data "aws_secretsmanager_secret" "dynatrace_log_token" {
  name = var.dynatrace_log_token
}

data "aws_secretsmanager_secret_version" "dynatrace_log_token_value" {
  secret_id = data.aws_secretsmanager_secret.dynatrace_log_token.id
}

resource "aws_s3_bucket" "ngem_api_firehose_backup_bucket" {
  bucket = "ngem-api-dynatrace-logs-backup-dev"
  tags = {
    Environment = "dev"
  }
}

resource "aws_iam_role" "ngem_api_firehose_role" {
  name = "ngem-api-firehose-delivery-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "firehose.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "ngem_api_firehose_policy" {
  name = "ngem-api-firehose-delivery-policy"
  role = aws_iam_role.ngem_api_firehose_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetBucketLocation",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.ngem_api_firehose_backup_bucket.arn,
          "${aws_s3_bucket.ngem_api_firehose_backup_bucket.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:PutLogEvents",
          "logs:CreateLogGroup",
          "logs:CreateLogStream"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = "arn:aws:secretsmanager:${var.aws_region}:*:secret:ngemapi/dev/dynatrace*"
      }
    ]
  })
}

resource "aws_kinesis_firehose_delivery_stream" "ngem_api_dynatrace_logs_stream" {
  name        = "ngem-api-dynatrace-logs-stream"
  destination = "http_endpoint"

  http_endpoint_configuration {
    url        = "https://${var.dynatrace_env_id}.live.dynatrace.com/api/v2/logs/ingest/aws_firehose"
    name       = "Dynatrace"
    access_key = data.aws_secretsmanager_secret_version.dynatrace_log_token_value.secret_string
    buffering_size     = 1
    buffering_interval = 60
    role_arn           = aws_iam_role.ngem_api_firehose_role.arn

    request_configuration {
      content_encoding = "GZIP"
    }

    s3_configuration {
      role_arn           = aws_iam_role.ngem_api_firehose_role.arn
      bucket_arn         = aws_s3_bucket.ngem_api_firehose_backup_bucket.arn
      buffering_size     = 5
      buffering_interval = 300
      compression_format = "GZIP"
    }
  }
}