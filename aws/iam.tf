resource "aws_iam_policy" "cs2_server_exec_policy" {
  name   = "cs2-server-exec-policy"
  policy = templatefile("policy/cs2-server-exec-policy.json", { str_aws_account_id = var.str_aws_account_id })
}


resource "aws_iam_policy" "cs2_server_ssm_policy" {
  name   = "cs2-server-ssm-policy"
  policy = templatefile("policy/cs2-server-ssm-policy.json", { str_aws_account_id = var.str_aws_account_id })
}


resource "aws_iam_role" "cs2_server_ecs_task_role" {
  name = "cs2-server-task-role"
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
  name = "cs2-server-ebs-role"
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
