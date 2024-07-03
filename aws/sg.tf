resource "aws_security_group" "cs2_server_nlb_sg" {
  name        = "cs2-server-nlb-sg-temp"
  description = "Allow inbound traffic to the cs2-server load balancer"
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


resource "aws_security_group" "cs2_server_app_sg" {
  name        = "cs2-server-app-sg-temp"
  description = "Allow inbound traffic to the cs2-server app"
  vpc_id      = data.aws_vpc.default.id

  ingress = [
    {
      description      = "Allow inbound tcp traffic to the cs2 server for rcon"
      from_port        = 27050
      to_port          = 27050
      protocol         = "tcp",
      prefix_list_ids  = []
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      security_groups  = [aws_security_group.cs2_server_nlb_sg.id]
      self             = false
    },
    {
      description      = "Allow inbound udp traffic to the cs2 server"
      from_port        = 27015
      to_port          = 27015
      protocol         = "udp"
      prefix_list_ids  = []
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      security_groups  = [aws_security_group.cs2_server_nlb_sg.id]
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
