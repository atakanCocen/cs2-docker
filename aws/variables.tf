variable "str_aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "str_aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "server_port" {
  description = "CS2 Server Port"
  type        = number
  default     = 27015
}

variable "rcon_port" {
  description = "CS2 RCON Port"
  type        = number
  default     = 27050
}
