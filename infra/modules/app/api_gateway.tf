resource "aws_apigatewayv2_stage" "lambda_stage" {
  api_id = data.terraform_remote_state.shared.outputs.shared_data.lambda_gateway_id

  name        = (
  	var.current_stage == "dev" || var.current_stage == "prod"
	? var.current_stage
	: "${var.current_stage}-${var.pr_id}"
  )
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id = data.terraform_remote_state.shared.outputs.shared_data.lambda_gateway_id

  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.app_lambda.invoke_arn
}

resource "aws_apigatewayv2_route" "app_route" {
  api_id = data.terraform_remote_state.shared.outputs.shared_data.lambda_gateway_id

  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
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
