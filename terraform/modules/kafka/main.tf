data "aws_caller_identity" "current" {}

locals {
  aws_account_id = data.aws_caller_identity.current.id
}

data "aws_vpc" "ngem_ops_cluster_vpc" {
  default = true
}

data "aws_subnets" "ngem_ops_cluster_private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.ngem_ops_cluster_vpc.id]
  }
  filter {
    name   = "availabilityZone"
    values = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1f"]
  }
}

data "aws_subnets" "ngem_ops_cluster_public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.ngem_ops_cluster_vpc.id]
  }
}

data "aws_subnet" "ngem_ops_private_subnet_cidrs" {
  for_each = toset(data.aws_subnets.ngem_ops_cluster_private_subnets.ids)
  id = each.value
}

resource "aws_cloudwatch_log_group" "ngem_ops_msk_log_group" {
  name              = "${var.msk_cluster_name}-log-group"
  retention_in_days = "0"
}

resource "aws_s3_bucket" "ngem_ops_msk_broker_logs" {
  bucket = "${var.msk_cluster_name}-logs-348542648035"
  tags = {
    Env = var.env
  }
}

resource "aws_msk_configuration" "ngem_ops_msk_config" {
  kafka_versions    = ["${var.msk_cluster_kafka_version}"]
  name              = "${var.msk_cluster_name}-config"
  server_properties = <<EOF
    auto.create.topics.enable = false
    delete.topic.enable = false
EOF
  lifecycle {
    ignore_changes = [server_properties]
  }
}

resource "aws_msk_cluster" "ngem_ops_msk_cluster" {
  cluster_name           = var.msk_cluster_name
  kafka_version          = "${var.msk_cluster_kafka_version}"
  number_of_broker_nodes = var.number_of_broker_nodes

  broker_node_group_info {
    instance_type = "${var.msk_cluster_instance_type}"
    storage_info {
      ebs_storage_info {
        volume_size = "${var.msk_cluster_ebs_storage_volume_size}"
      }
    }
    client_subnets  = slice(tolist(data.aws_subnets.ngem_ops_cluster_private_subnets.ids), 0, 2)
    security_groups = [aws_security_group.msk_cluster_security_group.id]

    connectivity_info {
      public_access {
        type = "DISABLED"
    }
  }
}

  #   connectivity_info {
  #     public_access {
  #       type = "DISABLED"
  #     }
  #     vpc_connectivity {
  #       client_authentication {
  #         sasl {
  #           iam = true
  #         }
  #       }
  #     }
  #   }
  # }

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS"
      in_cluster    = true
    }
  }

  client_authentication {
    sasl {
      iam = true
    }
  }

#  configuration_info {
#    arn      = aws_msk_configuration.ngem_ops_msk_config.arn
#    revision = aws_msk_configuration.ngem_ops_msk_config.latest_revision
#  }

  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = true
      }
      node_exporter {
        enabled_in_broker = true
      }
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.ngem_ops_msk_log_group.name
      }
      s3 {
        enabled = true
        bucket  = aws_s3_bucket.ngem_ops_msk_broker_logs.bucket
      }
    }
  }

  tags       = var.tags
  depends_on = [aws_s3_bucket.ngem_ops_msk_broker_logs]

  lifecycle {
    ignore_changes = [configuration_info[0].revision]
  }
}

resource "aws_security_group" "msk_cluster_security_group" {
  name   = "${var.msk_cluster_name}-sg"
  vpc_id = data.aws_vpc.ngem_ops_cluster_vpc.id
  ingress {
    from_port   = 9090
    to_port     = 9098
    protocol    = "TCP"
    cidr_blocks = [for s in data.aws_subnet.ngem_ops_private_subnet_cidrs : s.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_msk_cluster_policy" "ngem_ops_msk_cluster_policy" {
  cluster_arn = aws_msk_cluster.ngem_ops_msk_cluster.arn
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : { "AWS" : "arn:aws:iam::${var.aws_client_account_id}:root" },
        "Action" : [
          "kafka:CreateVpcConnection", "kafka:GetBootstrapBrokers",
          "kafka:DescribeCluster", "kafka:DescribeClusterV2", "kafka-cluster:*"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Principal" : { "AWS" : "arn:aws:iam::${var.aws_client_account_id}:root" },
        "Action" : "kafka-cluster:*",
        "Resource" : "arn:aws:kafka:${var.region}:${local.aws_account_id}:topic/domain-sample-event-v1-dlq/*"
      },
      {
        "Effect" : "Allow",
        "Principal" : { "AWS" : "arn:aws:iam::${var.aws_client_account_id}:root" },
        "Action" : "kafka-cluster:*",
        "Resource" : "arn:aws:kafka:${var.region}:${local.aws_account_id}:group/domain-sample-event-v1-dlq/*"
      }
    ]
  })
}