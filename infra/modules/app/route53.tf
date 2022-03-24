resource "aws_route53_record" "preview_record" {
  name    = aws_apigatewayv2_domain_name.api_gw_domain_name.domain_name
  type    = "A"
  zone_id = data.terraform_remote_state.shared.outputs.shared_data.route53_zone_id

  alias {
	name                   = aws_apigatewayv2_domain_name.api_gw_domain_name.domain_name_configuration[0].target_domain_name
	zone_id                = aws_apigatewayv2_domain_name.api_gw_domain_name.domain_name_configuration[0].hosted_zone_id
	evaluate_target_health = false
  }
}

