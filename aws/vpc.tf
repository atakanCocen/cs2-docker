data "aws_vpc" "main" {
  default = true
}


data "aws_subnet" "subnets" {
  for_each          = toset(["us-east-1a", "us-east-1b", "us-east-1c"])
  vpc_id            = data.aws_vpc.main.id
  availability_zone = each.key
  default_for_az    = true
}
