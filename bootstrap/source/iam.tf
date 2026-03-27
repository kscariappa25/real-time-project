resource "aws_iam_role" "codebuild_role" {
  name = "${var.source_iam_role_name}-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : ["codebuild.amazonaws.com", "codepipeline.amazonaws.com"]
        },
        "Effect" : "Allow"
      }
    ]
  })
}

resource "aws_iam_policy" "assume_role_policy" {
  name        = "${var.source_iam_role_name}-policy"
  description = "Assume Role permission for Destination and Sandbox Accounts"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Resource": "arn:aws:iam::348542648035:role/${var.destination_role_name}-role",
        "Action": "sts:AssumeRole"
      },
      {
        "Effect": "Allow",
        "Resource": "arn:aws:iam::626635426805:role/${var.sandbox_dest_role_name}",
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_permissions" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.assume_role_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_policy_aws_managed" {
  role       = aws_iam_role.codebuild_role.name
  for_each   = toset(var.cross_account_role_iam_policies)
  policy_arn = each.key
}
