output "bucket_name" {
  description = "AWS S3 bucket name"
  value       = aws_s3_bucket.s3_bucket.id
}
output "bucket_arn" {
  description = "AWS S3 bucket arn"
  value       = aws_s3_bucket.s3_bucket.arn
}
