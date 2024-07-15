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
  name = "cs2-server-cluster"
}


resource "aws_ecs_service" "cs2_server" {
  name                    = "cs2-server"
  cluster                 = aws_ecs_cluster.cs2_server.id
  task_definition         = data.aws_ecs_task_definition.cs2_server.arn
  desired_count           = 1
  launch_type             = "FARGATE"
  enable_ecs_managed_tags = true


  network_configuration {
    subnets          = [aws_subnet.private_subnet.id]
    security_groups  = [aws_security_group.cs2_server_app_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.cs2_server_tg.arn
    container_name   = "cs2-server"
    container_port   = var.server_port
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.cs2_server_rcon_tg.arn
    container_name   = "cs2-server"
    container_port   = var.rcon_port
  }

  health_check_grace_period_seconds = 900

  volume_configuration {
    name = "cs2-install"
    managed_ebs_volume {
      snapshot_id      = data.aws_ebs_snapshot.cs2_server_ecs_ebs_snapshot.id
      role_arn         = aws_iam_role.cs2_server_ebs_role.arn
      file_system_type = "ext4"
      size_in_gb       = 55
      iops             = 3000
      encrypted        = true
      volume_type      = "gp3"
    }
  }

  depends_on = [aws_iam_role.cs2_server_ebs_role, aws_iam_role.cs2_server_ecs_task_role]
}
