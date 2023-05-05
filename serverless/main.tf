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