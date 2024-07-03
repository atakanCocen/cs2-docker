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


data "aws_vpc" "default" {
  default = true
}


data "aws_subnet" "subnets" {
  for_each          = toset(["us-east-1a", "us-east-1b", "us-east-1c"])
  vpc_id            = data.aws_vpc.default.id
  availability_zone = each.key
  default_for_az    = true
}
