data "aws_caller_identity" "current" {}

locals {
  aws_account_id = data.aws_caller_identity.current.id
}

data "aws_vpc" "ngem_ops_cluster_vpc" {
  filter {
    name   = "tag:Name"
    values = ["main"]
  }
}

data "aws_subnets" "ngem_ops_cluster_private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.ngem_ops_cluster_vpc.id]
  }
  filter {
    name   = "tag:${var.private_subnet_tag_key_name}"
    values = ["${var.private_subnet_tag_value_name}"]
  }
  tags = {
    Name = "main-private-*"
  }
}

#########################################
# TARGET GROUP
#########################################
resource "aws_lb_target_group" "ngem_api_tg" {
  name        = "${var.api_name}-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.ngem_ops_cluster_vpc.id
  target_type = "ip"
  health_check {
    path                = var.health_check_path
    port                = "8080"
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }
}

resource "aws_lb_listener_rule" "api_rule" {
  listener_arn = var.listener_arn
  priority     = var.priority
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ngem_api_tg.arn
  }
  condition {
    path_pattern {
      values = [var.path_pattern]
    }
  }
}

##########################################
# IAM Role for ECS Task Execution Role
##########################################
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.api_name}-task-exec-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy" "ngem_api_secrets_access_policy" {
  name = "${var.api_name}-custom-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = "*"
      },
      {
        Sid    = "KafkaClusteraccessPermissions"
        Effect = "Allow"
        Action = [
          "kafka-cluster:Connect",
          "kafka-cluster:DescribeCluster",
          "kafka-cluster:DescribeTopic",
          "kafka-cluster:DescribeTopicDynamicConfiguration",
          "kafka-cluster:WriteData",
          "kafka-cluster:DescribeGroup",
          "kafka-cluster:ReadData",
          "kafka-cluster:AlterGroup",
          "kafka:*"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = "firehose:PutRecordBatch"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_exec_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ngem_api_secrets_access_policy.arn
}

#########################################
# IAM ROLES for ECS Task Role
#########################################
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.api_name}-task-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_s3_access" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "ngem_ecs_task_custom_attach" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ngem_api_secrets_access_policy.arn
}

##########################################
# ECS Task Definition
##########################################
resource "aws_ecs_task_definition" "ecs_producer_task" {
  family                   = "${var.api_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name       = "install-oneagent"
      image      = "alpine:latest"
      essential  = false
      entryPoint = ["/bin/sh", "-c"]
      command = [
        "ARCHIVE=$(mktemp) && wget -O $ARCHIVE \"$DT_API_URL/v1/deployment/installer/agent/unix/paas/latest?arch=x86&Api-Token=$DT_PAAS_TOKEN&$DT_ONEAGENT_OPTIONS\" && unzip -o -d /opt/dynatrace/oneagent $ARCHIVE && rm -f $ARCHIVE"
      ]
      environment = [
        { name = "DT_ONEAGENT_OPTIONS", value = "flavor=default&include=dotnet" }
      ]
      secrets = [
        {
          name      = "DT_API_URL"
          valueFrom = "arn:aws:secretsmanager:${var.region}:${local.aws_account_id}:secret:ngemapi/dev/dynatrace_endpoint-fE2Yoh"
        },
        {
          name      = "DT_PAAS_TOKEN"
          valueFrom = "arn:aws:secretsmanager:${var.region}:${local.aws_account_id}:secret:ngemapi/dev/dynatrace_paas_token-fE2Yoh"
        }
      ]
      mountPoints = [{ sourceVolume = "oneagent", containerPath = "/opt/dynatrace/oneagent" }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/dev/ngem-api-dev-ecs-cluster"
          "awslogs-region"        = "us-east-1"
          "awslogs-create-group"  = "true"
          "awslogs-stream-prefix" = "install-oneagent-new"
        }
      }
    },
    {
      name      = "log_router"
      image     = "public.ecr.aws/aws-observability/aws-for-fluent-bit:stable"
      essential = true
      firelensConfiguration = {
        type    = "fluentbit"
        options = { "enable-ecs-log-metadata" = "true" }
      }
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/dev/ngem-api-dev-ecs-cluster"
          "awslogs-region"        = "us-east-1"
          "awslogs-create-group"  = "true"
          "awslogs-stream-prefix" = "firelens"
        }
      }
      memoryReservation = 50
    },
    {
      name  = var.container_name
      image = "${var.source_account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.container_repo_name}:${var.image_tag}"
      secrets = [
        {
          name      = "NGEM_MSK_ENDPOINT_DEV"
          valueFrom = "arn:aws:secretsmanager:${var.region}:${local.aws_account_id}:secret:ngemapi/dev/producer-ReWBpw"
        },
        {
          name      = "NGEM_IAM_ROLE_ARN_DEV"
          valueFrom = "arn:aws:secretsmanager:${var.region}:${local.aws_account_id}:secret:ngemapi/dev/producer_iam-b0NG4p"
        },
        {
          name      = "SB_AWS_GLUE_SAMPLE_REG_ARN"
          valueFrom = "arn:aws:secretsmanager:${var.region}:${local.aws_account_id}:secret:ngemapi/dev/sandbox_glue_schema_reg_sample-yuensx"
        },
        {
          name      = "DT_CONN_POINT"
          valueFrom = "arn:aws:secretsmanager:${var.region}:${local.aws_account_id}:secret:ngemapi/dev/dynatrace_connection-i5f8Ug"
        }
      ]
      dependsOn   = [{ containerName = "install-oneagent", condition = "COMPLETE" }]
      environment = [{ name = "LD_PRELOAD", value = "/opt/dynatrace/oneagent/agent/lib64/liboneagentproc.so" }]
      mountPoints = [{ sourceVolume = "oneagent", containerPath = "/opt/dynatrace/oneagent" }]
      essential   = true
      portMappings = [{ containerPort = 8080, hostPort = 8080, protocol = "tcp" }]
      logConfiguration = {
        logDriver = "awsfirelens"
        options = {
          "Name"            = "firehose"
          "region"          = var.region
          "delivery_stream" = "ngem-api-dynatrace-logs-stream"
        }
      }
    }
  ])

  volume {
    name = "oneagent"
  }
}

##########################################
# ECS Service
##########################################
resource "aws_ecs_service" "ecs_producer_service" {
  name                   = "${var.api_name}-svc"
  cluster                = var.ngem_api_ecs_cluster_id
  task_definition        = aws_ecs_task_definition.ecs_producer_task.arn
  desired_count          = 1
  launch_type            = "FARGATE"
  enable_execute_command = true

  lifecycle {
    ignore_changes = [task_definition]
  }

  network_configuration {
    subnets          = data.aws_subnets.ngem_ops_cluster_private_subnets.ids
    security_groups  = [var.security_group]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ngem_api_tg.arn
    container_name   = var.container_name
    container_port   = 8080
  }

  force_new_deployment = true
}