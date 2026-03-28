data "aws_vpc" "dev_vpc" {
  filter {
    name   = "tag:Name"
    values = ["ngem-api-dev-vpc-us-west-2"]
  }
}
data "aws_subnets" "dev_private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.dev_vpc.id]
  }
  filter {
    name   = "tag:type"
    values = ["private"]
  }
  filter {
    name   = "availabilityZone"
    values = ["us-west-2b"]
  }
}
resource "aws_security_group" "endpoint_sg" {
  name   = "${var.name}-endpoint-sg"
  vpc_id = data.aws_vpc.dev_vpc.id
  ingress {
    from_port   = 9098
    to_port     = 9098
    protocol    = "TCP"
    cidr_blocks = [data.aws_vpc.dev_vpc.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_vpc_endpoint" "msk_endpoint" {
  vpc_id              = data.aws_vpc.dev_vpc.id
  service_name        = var.endpoint_service_name
  vpc_endpoint_type   = "Interface"
  subnet_ids          = data.aws_subnets.dev_private_subnets.ids
  security_group_ids  = [aws_security_group.endpoint_sg.id]
  tags                = merge(var.tags, { Name = "${var.name}-vpc-endpoint" })
}
