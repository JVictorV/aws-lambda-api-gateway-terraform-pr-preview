resource "aws_apigatewayv2_api" "lambda_gateway" {
  name          = var.lambda_gateway_name
  protocol_type = "HTTP"

  lifecycle {
	prevent_destroy = true
  }

  tags = {
	Name = "${var.app_name} API Gateway"
	Owner = "Terraform"
  }
}

data "aws_caller_identity" "current" {}

resource "aws_apigatewayv2_integration" "generic_lambda_integration" {
  api_id           = aws_apigatewayv2_api.lambda_gateway.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"

  integration_uri = "arn:aws:lambda:${var.aws_region}:${data.aws_caller_identity.current.account_id}:function:${"$"}{stageVariables.function}"
}

resource "aws_apigatewayv2_route" "app_route" {
  api_id = aws_apigatewayv2_api.lambda_gateway.id

  route_key = "ANY /"
  target    = "integrations/${aws_apigatewayv2_integration.generic_lambda_integration.id}"
}
