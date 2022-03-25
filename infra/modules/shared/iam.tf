resource "aws_iam_role" "lambda_execution_role" {
  name = "${var.app_name}_lambda_execution_role"

  assume_role_policy = jsonencode({
	Version : "2012-10-17",
	Statement : [
	  {
		Effect : "Allow",
		Principal : {
		  Service : "lambda.amazonaws.com"
		},
		Action : "sts:AssumeRole"
	  }
	]
  })


  tags = {
	Name = "${var.app_name} IAM Role"
	Owner = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "lambda_role_policy" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
