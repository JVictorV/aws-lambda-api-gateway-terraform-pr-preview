resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = var.lambda_bucket_name
  force_destroy = "true"

  tags = {
	Name = "${var.app_name} Lambda Function Code Bucket"
	Owner = "Terraform"
  }
}

