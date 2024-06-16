terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.54.1"
    }
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "us-east-1"
}


#### BEGIN IAM ####


resource "aws_iam_policy" "cs2_server_exec_policy" {
  name   = "cs2-server-exec-policy"
  policy = templatefile("policy/cs2-server-exec-policy.json", { str_aws_account_id = var.str_aws_account_id })
}


resource "aws_iam_policy" "cs2_server_ssm_policy" {
  name   = "cs2-server-ssm-policy"
  policy = templatefile("policy/cs2-server-ssm-policy.json", { str_aws_account_id = var.str_aws_account_id })
}


resource "aws_iam_role" "cs2_server_ecs_task_role" {
  name = "cs2-server-ecs-task-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    aws_iam_policy.cs2_server_exec_policy.arn,
    aws_iam_policy.cs2_server_ssm_policy.arn
  ]
}


resource "aws_iam_role" "cs2_server_ebs_role" {
  name = "cs2-server-ebs-role-test"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSInfrastructureRolePolicyForVolumes"
  ]
}


#### END IAM ####

#### BEGIN VPC ####


data "aws_vpc" "default" {
  default = true
}


data "aws_subnet" "subnets" {
  for_each          = toset(["us-east-1a", "us-east-1b", "us-east-1c"])
  vpc_id            = data.aws_vpc.default.id
  availability_zone = each.key
  default_for_az    = true
}


resource "aws_security_group" "cs2_server_app_sg" {
  name        = "cs2-server-app-sg"
  description = "Allow inbound traffic to the cs2-server app"
  vpc_id      = data.aws_vpc.default.id

  ingress = [
    {
      description      = "Allow inbound tcp traffic to the cs2 server for rcon"
      from_port        = 27050
      to_port          = 27050
      protocol         = "tcp",
      prefix_list_ids  = []
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Allow inbound udp traffic to the cs2 server"
      from_port        = 27015
      to_port          = 27015
      protocol         = "udp"
      prefix_list_ids  = []
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      security_groups  = []
      self             = false
    }
  ]
  egress = [
    {
      description      = "Allow all outbound tcp traffic from the cs2 server"
      from_port        = 0
      to_port          = 65535
      protocol         = "tcp"
      prefix_list_ids  = []
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Allow all outbound udp traffic from the cs2 server"
      from_port        = 0
      to_port          = 65535
      protocol         = "udp"
      prefix_list_ids  = []
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      self             = false
      security_groups  = []
    }
  ]
}


#### END VPC ####


#### BEGIN ECS ####


data "aws_ebs_snapshot" "cs2_server_ecs_ebs_snapshot" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "tag:Name"
    values = ["cs2-install"]
  }
}


data "aws_ecs_task_definition" "cs2_server" {
  task_definition = "cs2-server"
}


resource "aws_ecs_cluster" "cs2_server" {
  name = "cs2-server"
}


resource "aws_ecs_service" "cs2_server" {
  name            = "cs2-server"
  cluster         = aws_ecs_cluster.cs2_server.id
  task_definition = data.aws_ecs_task_definition.cs2_server.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = values(data.aws_subnet.subnets)[*].id
    security_groups  = [aws_security_group.cs2_server_app_sg.id]
    assign_public_ip = true
  }

  volume_configuration {
    name = "cs2-install"
    managed_ebs_volume {
      snapshot_id      = data.aws_ebs_snapshot.cs2_server_ecs_ebs_snapshot.id
      role_arn         = aws_iam_role.cs2_server_ebs_role.arn
      file_system_type = "ext4"
    }
  }
}


#### END ECS ####
