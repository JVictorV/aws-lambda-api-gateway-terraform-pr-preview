output "certificate_arn" {
  value = aws_acm_certificate.certificate.arn
}

output "lambda_bucket_id" {
  value = aws_s3_bucket.lambda_bucket.id
}

output "lambda_gateway_id" {
  value = aws_apigatewayv2_api.lambda_gateway.id
}

output "lambda_gateway_execution_arn" {
  value = aws_apigatewayv2_api.lambda_gateway.execution_arn
}

output "lambda_execution_role_arn" {
  value = aws_iam_role.lambda_execution_role.arn
}

output "route53_zone_id" {
  value = aws_route53_zone.base_url.zone_id
}

output "lambda_gateway_api_endpoint" {
  value = aws_apigatewayv2_api.lambda_gateway.api_endpoint
}
