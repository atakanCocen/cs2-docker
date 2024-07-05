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

variable "use_existing_route53_zone" {
  description = "Use Existing Route53 Zone"
  type        = bool
  default     = false
}


variable "domain_name" {
  description = "Domain Name"
  type        = string
}

variable "subdomain_name" {
  description = "Subdomain Name"
  type        = string
  default     = "cs2"
}
