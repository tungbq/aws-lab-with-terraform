// Saving sourcecode to s3
data "archive_file" "lambda_hello_world" {
  type = "zip"

  source_dir  = "${path.module}/assets"
  output_path = "${path.module}/assets/lamda_function.zip"
}

resource "aws_s3_bucket" "tungbq_lamda_source" {
  bucket = "tungbq-lamda-source"

  tags = {
    Name        = "S3 bucket to store lamda source code"
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
  handler = "lamda_function.lambda_handler"

  source_code_hash = data.archive_file.lambda_hello_world.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "hello_world" {
  name = "/aws/lambda/${aws_lambda_function.hello_world.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "dynamodb_task_permissions" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.dynamodb_access.arn
}

resource "aws_iam_policy" "dynamodb_access" {
  name = "dynamodb-access"
  policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
    {
        "Sid": "VisualEditor0",
        "Effect": "Allow",
        "Action": [
            "dynamodb:PutItem",
            "dynamodb:DeleteItem",
            "dynamodb:GetItem",
            "dynamodb:Scan",
            "dynamodb:Query",
            "dynamodb:UpdateItem"
        ],
        "Resource": "${aws_dynamodb_table.basic_dynamodb_table.arn}"
    }
    ]
}
EOF
}
