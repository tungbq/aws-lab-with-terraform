// Saving sourcecode to s3
data "archive_file" "lambda_hello_world" {
  type = "zip"

  source_dir  = "${path.module}/assets/lamda_function.py"
  output_path = "${path.module}/assets/lamda_function.zip"
}

resource "aws_s3_bucket" "tungbq_lamda_source" {
  bucket = "tungbq-lamda-source"

  tags = {
    Name        = "S3 bucket to store website"
    Environment = "Dev"
  }
}


resource "aws_s3_object" "lambda_hello_world" {
  bucket = aws_s3_bucket.tungbq_lamda_source.id

  key    = "lamda_function.zip"
  source = data.archive_file.lambda_hello_world.output_path

  etag = filemd5(data.archive_file.lambda_hello_world.output_path)
}

resource "aws_lambda_function" "hello_world" {
  function_name = "HelloWorld"

  s3_bucket = aws_s3_bucket.tungbq_lamda_source.id
  s3_key    = aws_s3_object.lambda_hello_world.key

  runtime = "python3.8"

  source_code_hash = data.archive_file.lambda_hello_world.output_base64sha256

  # role = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "hello_world" {
  name = "/aws/lambda/${aws_lambda_function.hello_world.function_name}"

  retention_in_days = 30
}
