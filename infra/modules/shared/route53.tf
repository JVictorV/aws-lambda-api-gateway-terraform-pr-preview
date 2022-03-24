resource "aws_route53_zone" "base_url" {
  name = var.base_url

  lifecycle {
	prevent_destroy = true
  }

  tags = {
	Name = "${var.app_name} Route53 Hosted Zone"
	Owner = "Terraform"
  }
}

resource "aws_route53_record" "certificate_validation" {
  for_each = {
 	for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
		name    = dvo.resource_record_name
		record  = dvo.resource_record_value
		type    = dvo.resource_record_type
		zone_id = aws_route53_zone.base_url.zone_id
 	}
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id

  lifecycle {
	prevent_destroy = true
  }
}
