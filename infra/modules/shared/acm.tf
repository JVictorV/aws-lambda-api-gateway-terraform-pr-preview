resource "aws_acm_certificate" "certificate" {
  domain_name               = var.base_url
  subject_alternative_names = ["*.${var.base_url}"]
  validation_method         = "DNS"

  lifecycle {
	create_before_destroy = true
  }

  tags = {
	Name = "${var.app_name} TLS Certificate"
	Owner = "Terraform"
  }
}


resource "aws_acm_certificate_validation" "certificate_validation" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.certificate_validation : record.fqdn]
}
