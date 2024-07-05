locals {
  zone_id = var.use_existing_route53_zone ? one(data.aws_route53_zone.cs2_server_zone[*].zone_id) : one(aws_route53_zone.cs2_server_zone[*].zone_id)
}

data "aws_route53_zone" "cs2_server_zone" {
  count = var.use_existing_route53_zone ? 1 : 0
  name  = var.domain_name
}

resource "aws_route53_zone" "cs2_server_zone" {
  count = var.use_existing_route53_zone ? 0 : 1
  name  = var.domain_name
}

resource "aws_route53_record" "cs2_server_record" {
  zone_id = local.zone_id
  name    = "${var.subdomain_name}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.cs2_server.dns_name
    zone_id                = aws_lb.cs2_server.zone_id
    evaluate_target_health = true
  }
}
