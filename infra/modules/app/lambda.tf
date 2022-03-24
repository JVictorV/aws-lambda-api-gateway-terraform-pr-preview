resource "aws_lambda_function" "app_lambda" {
  function_name = "${var.app_name}-${var.current_stage}-${var.commit_hash}"

  s3_bucket = data.terraform_remote_state.shared.outputs.shared_data.lambda_bucket_id
  s3_key    = aws_s3_object.lambda_code_zip.key

  runtime = "nodejs14.x"

  # O nome deve ser referente ao nome do arquivo que será executado
  handler = "app.handler"

  source_code_hash = data.archive_file.lambda_zipped_code.output_base64sha256

  role = data.terraform_remote_state.shared.outputs.shared_data.lambda_execution_role_arn
}

