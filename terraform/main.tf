provider "aws" {
  region                      = var.aws_region
  secret_key                  = var.aws_secret_key
  access_key                  = var.aws_access_key
  skip_credentials_validation = true
  skip_requesting_account_id  = true

  endpoints {
    ecs = var.localstack_endpoint
    ecr = var.localstack_endpoint
    ec2 = var.localstack_endpoint
  }
}

resource "aws_ecs_cluster" "medusa_cluster" {
  name = "medusa-cluster"
}

# --- VPC Networking ---
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_security_group" "ecs_sg" {
  name        = "ecs_sg"
  description = "Allow all traffic for ECS task"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_task_definition" "medusa_task" {
  family                   = "medusa-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  container_definitions = jsonencode([
    {
      name      = "medusa"
      image     = var.ecr_image_url
      essential = true
      portMappings = [
        {
          containerPort = 9000
          hostPort      = 9000
          protocol      = "tcp"
        }
      ]
      environment = [
        { name = "NODE_ENV", value = "production" },
        { name = "MEDUSA_ADMIN_ONBOARDING_TYPE", value = "default" },
        { name = "STORE_CORS", value = var.cors_origins },
        { name = "ADMIN_CORS", value = var.cors_origins },
        { name = "AUTH_CORS", value = var.cors_origins },
        { name = "REDIS_URL", value = var.redis_url },
        { name = "JWT_SECRET", value = var.jwt_secret },
        { name = "COOKIE_SECRET", value = var.cookie_secret },
        { name = "DATABASE_URL", value = var.db_url }
      ]
  }])
}

resource "aws_ecs_service" "medusa_service" {
  name            = "medusa-service"
  cluster         = aws_ecs_cluster.medusa_cluster.id
  task_definition = aws_ecs_task_definition.medusa_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.subnet.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}
