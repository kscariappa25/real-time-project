resource "aws_ecr_repository" "ecr_repository" {
  name                 = var.ecr_repo_name
  image_tag_mutability = var.ecr_mutability_status
  image_scanning_configuration {
    scan_on_push = false
  }
  tags = var.ecr_tags
}
resource "aws_ecr_repository_policy" "ecr_policy" {
  repository = aws_ecr_repository.ecr_repository.name
  policy = jsonencode({
    "Version": "2012-10-17"
    "Statement": [
      {
        "Action": ["ecr:BatchCheckLayerAvailability","ecr:BatchGetImage","ecr:GetDownloadUrlForLayer"],
        "Principal": {"AWS": ["arn:aws:iam::${var.destination_aws_account_id}:root"]},
        "Effect": "Allow",
        "Sid": "AllowPullForAccountDevelopment"
      }
    ]
  })
}
