# create a IAM role on the Destination account for deploying the infra from the source account
resource "aws_iam_role" "cross_account_role" {
  name = "${var.destination_cross_account_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${var.source_aws_accountid}:role/${var.source_aws_role_name}-role"
        },
        Action = "sts:AssumeRole"
      },
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${var.source_aws_accountid}:role/${var.source_code_aws_role_name}"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_iam_policy" "cross_account_policy" {
  name        = "${var.destination_cross_account_name}-policy"
  description = "Policy to allow creating resource in cross account"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "cognito-idp:DescribeUserPoolClient","acm:ListCertificates","acm:DescribeCertificate",
          "iam:ListServerCertificates","iam:GetServerCertificate","iam:CreateServiceLinkedRole",
          "waf-regional:GetWebACL","waf-regional:GetWebACLForResource","waf-regional:AssociateWebACL",
          "waf-regional:DisassociateWebACL","wafv2:GetWebACL","wafv2:GetWebACLForResource",
          "wafv2:AssociateWebACL","wafv2:DisassociateWebACL","shield:GetSubscriptionState",
          "shield:DescribeProtection","shield:CreateProtection","shield:DeleteProtection","dynamodb:*"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : ["dynamodb:GetItem","dynamodb:PutItem","dynamodb:DeleteItem","dynamodb:Scan"],
        "Resource" : "arn:aws:dynamodb:${var.region}:${var.source_aws_accountid}:table/${var.source_dynamodb_table_name}"
      },
      {
        "Effect" : "Allow",
        "Action" : ["eks:DescribeCluster","eks:ListClusters"],
        "Resource" : "*"
      },
      {
        "Effect": "Allow",
        "Action": ["ecs:DescribeServices","ecs:UpdateService","ecs:RegisterTaskDefinition","ecs:DescribeTaskDefinition","iam:PassRole","ecs:*"],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": ["s3:Get*"],
        "Resource": ["arn:aws:s3:::${var.source_account_producer_s3_bucket_name}/*"]
      },
      {
        "Effect": "Allow",
        "Action": ["s3:ListBucket"],
        "Resource": ["arn:aws:s3:::${var.source_account_producer_s3_bucket_name}"]
      },
      {
        "Effect": "Allow",
        "Action": ["kms:DescribeKey","kms:GenerateDataKey*","kms:Encrypt","kms:ReEncrypt*","kms:Decrypt"],
        "Resource": ["arn:aws:kms:${var.region}:${var.source_aws_accountid}:key/${var.source_account_kms_id}"]
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "attach_policy_aws_managed" {
  role       = aws_iam_role.cross_account_role.name
  for_each   = toset(var.cross_account_role_iam_policies)
  policy_arn = each.key
}
resource "aws_iam_role_policy_attachment" "attach_policy_customer_managed" {
  role       = aws_iam_role.cross_account_role.name
  policy_arn = aws_iam_policy.cross_account_policy.arn
}
