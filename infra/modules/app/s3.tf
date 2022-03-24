data "archive_file" "lambda_zipped_code" {
  type        = "zip"
  source_dir  = "${path.module}/../../../src"
  output_path = "${path.module}/../../../${var.app_name}-${var.commit_hash}.zip"
}

resource "aws_s3_object" "lambda_code_zip" {
  bucket = data.terraform_remote_state.shared.outputs.shared_data.lambda_bucket_id

  key    = "${var.app_name}-${var.commit_hash}.zip"
  source = data.archive_file.lambda_zipped_code.output_path

  etag = filemd5(data.archive_file.lambda_zipped_code.output_path)
}
