data "aws_caller_identity" "current" {}

locals {
  aws_account_id = data.aws_caller_identity.current.id
}

resource "aws_msk_vpc_connection" "multi-vpc-enabled" {
  authentication     = "SASL_IAM"
  target_cluster_arn = var.cluster_arn
  vpc_id             = var.vpc_id
  client_subnets     = var.private_subnet_ids
  security_groups    = [aws_security_group.msk_cluster_security_group.id]
  depends_on         = [aws_security_group.msk_cluster_security_group]
}

resource "aws_security_group" "msk_cluster_security_group" {
  name   = var.aws_msk_multi_connection_sg
  vpc_id = var.vpc_id

  ingress {
    from_port   = 14001
    to_port     = 14100
    protocol    = "TCP"
    cidr_blocks = var.development_account_vpc_cidr_blocks
    description = "Development account VPC cidr/us-west-2"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}