data "aws_iam_policy_document" "iam_service_role_assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = var.assume_services
    }
  }
}
resource "aws_iam_role" "iam_service_role" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.iam_service_role_assume_policy.json
}
resource "aws_iam_role_policy_attachment" "iam_service_role_policy_attachment" {
  policy_arn = var.iam_service_role_policy_arn
  role       = aws_iam_role.iam_service_role.name
}
