resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  force_destroy = true
  tags = var.bucket_tags
}

resource "aws_s3_bucket_versioning" "s3_bucket_state_state" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_encryption" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "example_policy" {
  bucket = aws_s3_bucket.s3_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowSourceAccountCodePipeline"
        Effect    = "Allow"
        Principal = {
          AWS = [
            "arn:aws:iam::${var.source_aws_account_id}:role/ngem-api-ops-codepipeline-manager-role",
            "arn:aws:iam::${var.source_aws_account_id}:role/ngem-api-ops-codebuild-manager-role"
          ]
        }
        Action   = ["s3:Get*", "s3:Put*", "s3:ListBucket"]
        Resource = [
          "arn:aws:s3:::${var.bucket_name}",
          "arn:aws:s3:::${var.bucket_name}/*"
        ]
      },
      {
        Sid       = "AllowDevAccountAccess"
        Effect    = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.destination_aws_account_id}:root"
        }
        Action   = ["s3:Get*", "s3:Put*"]
        Resource = "arn:aws:s3:::${var.bucket_name}/*"
      },
      {
        Sid       = "AllowDevAccountListBucket"
        Effect    = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.destination_aws_account_id}:root"
        }
        Action   = "s3:ListBucket"
        Resource = "arn:aws:s3:::${var.bucket_name}"
      }
    ]
  })
}