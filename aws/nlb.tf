data "aws_eip" "cs2_server_ip" {
  filter {
    name   = "tag:Name"
    values = ["cs2-server"]
  }
}


resource "aws_lb" "cs2_server" {
  name               = "cs2-server-nlb"
  load_balancer_type = "network"
  security_groups    = [aws_security_group.cs2_server_nlb_sg.id]

  subnet_mapping {
    subnet_id     = values(data.aws_subnet.subnets)[0].id
    allocation_id = data.aws_eip.cs2_server_ip.id
  }
}


resource "aws_lb_listener" "cs2_server_nlb_listener" {
  load_balancer_arn = aws_lb.cs2_server.arn
  port              = 27015
  protocol          = "UDP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cs2_server_tg.arn
  }
}


resource "aws_lb_listener" "cs2_server_nlb_rcon_listener" {
  load_balancer_arn = aws_lb.cs2_server.arn
  port              = 27050
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cs2_server_rcon_tg.arn
  }
}

resource "aws_lb_target_group" "cs2_server_tg" {
  name        = "cs2-server-tg"
  port        = 27015
  protocol    = "UDP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"

  health_check {
    protocol = "TCP"
    port     = 27050
    interval = 300
  }
}

resource "aws_lb_target_group" "cs2_server_rcon_tg" {
  name        = "cs2-server-rcon-tg"
  port        = 27050
  protocol    = "TCP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"

  health_check {
    protocol = "TCP"
    port     = 27050
    interval = 300
  }
}
