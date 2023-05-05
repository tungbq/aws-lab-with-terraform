terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
 
provider "aws" {
  region = "us-east-1"
}

# IAM role for Lambda

resource "aws_iam_role" "lamda_apigateway_role" {
  name = "lamda_apigateway_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# IAM policy
resource "aws_iam_policy" "lamda_apigateway_policy" {
  name = "lamda_apigateway_policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:UpdateItem"
        ],
        Effect = "Allow",
        Resource = ["*"]
      },
      {
        Resource = ["*"],
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect = "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lamda_apigateway_role_policy" {
  policy_arn = aws_iam_policy.lamda_apigateway_policy.arn
  role = aws_iam_role.lamda_apigateway_role.name
}

# Create Lambda function
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda_http.py"
  output_path = "lambda_http_payload.zip"
}

resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "lambda_http_payload.zip"
  function_name = "lambda_function_name"
  role          = aws_iam_role.lamda_apigateway_role.arn

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.8"
  handler = "lambda_http.lambda_handler"
  environment {
    variables = {
      foo = "bar"
    }
  }
}