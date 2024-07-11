data "aws_ecs_task_definition" "cs2_server_ecs_task_definition" {
  task_definition = "cs2-server"
}

data "aws_ebs_snapshot" "cs2_server_ebs_snapshot" {
  filter {
    name = "tag:Name"
    values = [ "cs2-install" ]
  }
  most_recent = true
}

resource "aws_ecs_cluster" "cs2_server_cluster" {
  name = "cs2-server-cluster"
}

resource "aws_ecs_service" "cs2_server_service" {
  name = "cs2-server-service"
  cluster = aws_ecs_cluster.cs2_server_cluster.id
  task_definition = data.aws_ecs_task_definition.cs2_server_ecs_task_definition.arn
  desired_count = 1
  launch_type = "FARGATE"
   network_configuration {
    subnets          = [aws_subnet.public_subnet.id]
    assign_public_ip = true
  }

  volume_configuration {
    name = "cs2-install"
    managed_ebs_volume {
      snapshot_id = data.aws_ebs_snapshot.cs2_server_ebs_snapshot.id
      role_arn = aws_iam_role.cs2_server_ebs_role.arn
      file_system_type = "ext4"
      volume_type = "gp3"
      encrypted = true
    }
  }
}