locals {
  stage_name = (
  	var.current_stage == "dev" || var.current_stage == "prod"
  	? var.current_stage
  	: "${var.current_stage}-${var.pr_id}"
  )
}

resource "aws_apigatewayv2_stage" "lambda_stage" {
  api_id = data.terraform_remote_state.shared.outputs.shared_data.lambda_gateway_id

  name        = "${local.stage_name}-stage"
  auto_deploy = true

  stage_variables = {
	function = aws_lambda_function.app_lambda.function_name
  }
}

resource "aws_lambda_permission" "api_gw_lambda_permission" {
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.app_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${data.terraform_remote_state.shared.outputs.shared_data.lambda_gateway_execution_arn}/*/*/*"
}

resource "aws_apigatewayv2_domain_name" "api_gw_domain_name" {
  domain_name = (
 	var.current_stage == "prod" ? var.base_url :
 	var.current_stage == "dev" ? "${var.current_stage}.${var.base_url}" :
 	"${var.current_stage}-${var.pr_id}.${var.base_url}"
  )

  domain_name_configuration {
	certificate_arn = data.terraform_remote_state.shared.outputs.shared_data.certificate_arn
	endpoint_type   = "REGIONAL"
	security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_api_mapping" "api_gw_mapping" {
  api_id      = data.terraform_remote_state.shared.outputs.shared_data.lambda_gateway_id
  domain_name = aws_apigatewayv2_domain_name.api_gw_domain_name.id
  stage       = aws_apigatewayv2_stage.lambda_stage.id
}
