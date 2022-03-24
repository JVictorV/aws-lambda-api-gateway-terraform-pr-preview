resource "aws_apigatewayv2_api" "lambda_gateway" {
  name          = var.lambda_gateway_name
  protocol_type = "HTTP"

  lifecycle {
	prevent_destroy = false
  }

  tags = {
	Name = "${var.app_name} API Gateway"
	Owner = "Terraform"
  }
}
