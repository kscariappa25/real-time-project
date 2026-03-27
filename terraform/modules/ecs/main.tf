data "aws_caller_identity" "current" {}

data "aws_vpc" "ngem_ops_cluster_vpc" {
  default = true
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.ngem_ops_cluster_vpc.id]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.ngem_ops_cluster_vpc.id]
  }
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${var.environment}/${var.cluster_name}"
  retention_in_days = 30
}

resource "aws_ecs_cluster" "ngem_ops_ecs_cluster" {
  name = var.cluster_name
  tags = var.tags
}

resource "aws_security_group" "alb_sg" {
  name   = "${var.cluster_name}-alb-sg"
  vpc_id = data.aws_vpc.ngem_ops_cluster_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_sg" {
  name   = "${var.cluster_name}-ecs-sg"
  vpc_id = data.aws_vpc.ngem_ops_cluster_vpc.id
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "ngem_api_alb" {
  name               = "${var.cluster_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = data.aws_subnets.public.ids
  tags               = var.tags
}

resource "aws_lb_target_group" "producer_tg" {
  name        = "prod-tg-${var.environment}"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.ngem_ops_cluster_vpc.id
  target_type = "ip"
  health_check {
    path                = "/health"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    interval            = 30
  }
}

resource "aws_lb_target_group" "consumer_tg" {
  name        = "con-tg-${var.environment}"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.ngem_ops_cluster_vpc.id
  target_type = "ip"
  health_check {
    path                = "/health"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    interval            = 30
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.ngem_api_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.producer_tg.arn
  }
}

resource "aws_lb_listener_rule" "producer_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 10
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.producer_tg.arn
  }
  condition {
    path_pattern {
      values = ["/producer/*"]
    }
  }
}

resource "aws_lb_listener_rule" "consumer_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 20
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.consumer_tg.arn
  }
  condition {
    path_pattern {
      values = ["/consumer/*"]
    }
  }
}

resource "aws_iam_role" "ecs_task_exec_role" {
  name = "${var.cluster_name}-task-exec-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec_policy" {
  role       = aws_iam_role.ecs_task_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.cluster_name}-task-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_s3_policy" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_ecs_task_definition" "producer_task" {
  family                   = "${var.cluster_name}-producer"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_task_exec_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name         = "producer-app"
      image        = "${var.destination_account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.producer_container_repo_name}:${var.image_tag}"
      essential    = true
      portMappings = [{ containerPort = 8080, protocol = "tcp" }]
      environment  = [
        {
          name  = "Kafka__BootstrapServers"
          value = "b-1-public.ngemapimskclusterdev.tmgsr6.c14.kafka.us-west-2.amazonaws.com:9198,b-2-public.ngemapimskclusterdev.tmgsr6.c14.kafka.us-west-2.amazonaws.com:9198"
        },
        {
          name  = "Kafka__Topic"
          value = "sample-events"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.environment}/${var.cluster_name}"
          awslogs-region        = var.region
          awslogs-stream-prefix = "producer"
        }
      }
    }
  ])
}

resource "aws_ecs_task_definition" "consumer_task" {
  family                   = "${var.cluster_name}-consumer"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_exec_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name         = "consumer-app"
      image        = "${var.destination_account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.consumer_container_repo_name}:${var.image_tag}"
      essential    = true
      portMappings = [{ containerPort = 8080, protocol = "tcp" }]
      environment  = [
        {
          name  = "Kafka__BootstrapServers"
          value = "b-1-public.ngemapimskclusterdev.tmgsr6.c14.kafka.us-west-2.amazonaws.com:9198,b-2-public.ngemapimskclusterdev.tmgsr6.c14.kafka.us-west-2.amazonaws.com:9198"
        },
        {
          name  = "Kafka__Topic"
          value = "sample-events"
        },
        {
          name  = "Kafka__GroupId"
          value = "consumer-api-group"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.environment}/${var.cluster_name}"
          awslogs-region        = var.region
          awslogs-stream-prefix = "consumer"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "producer_service" {
  name                   = "${var.cluster_name}-prd-srv"
  cluster                = aws_ecs_cluster.ngem_ops_ecs_cluster.id
  task_definition        = aws_ecs_task_definition.producer_task.arn
  desired_count          = 1
  launch_type            = "FARGATE"
  enable_execute_command = true

  network_configuration {
    subnets          = data.aws_subnets.private.ids
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.producer_tg.arn
    container_name   = "producer-app"
    container_port   = 8080
  }

  lifecycle { ignore_changes = [task_definition] }
}

resource "aws_ecs_service" "consumer_service" {
  name            = "${var.cluster_name}-con-svc"
  cluster         = aws_ecs_cluster.ngem_ops_ecs_cluster.id
  task_definition = aws_ecs_task_definition.consumer_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.private.ids
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.consumer_tg.arn
    container_name   = "consumer-app"
    container_port   = 8080
  }

  lifecycle { ignore_changes = [task_definition] }
}
