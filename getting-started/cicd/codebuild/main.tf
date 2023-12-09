provider "aws" {
  region = "us-east-1" # Replace with your desired region
}

# Create S3 buckets
resource "aws_s3_bucket" "demo_aws_codebuild_bucket_output" {
  bucket = "tungbq-demo-aws-codebuild-bucket-output"

  tags = {
    Name        = "S3 bucket to store output code"
    Environment = "Dev"
  }

  force_destroy = true
}



data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "demo_codebuild" {
  name               = "demo_codebuild"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "demo_codebuild" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
    ]

    resources = ["*"]
  }


  statement {
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.demo_aws_codebuild_bucket_output.arn,
      "${aws_s3_bucket.demo_aws_codebuild_bucket_output.arn}/*",
    ]
  }
}

resource "aws_iam_role_policy" "demo_codebuild" {
  role   = aws_iam_role.demo_codebuild.name
  policy = data.aws_iam_policy_document.demo_codebuild.json
}


### CODE BUILD PROJECT
resource "aws_codebuild_project" "demo_project" {
  name           = "demo_project"
  description    = "Demo project"
  build_timeout  = 5
  queued_timeout = 5

  service_role = aws_iam_role.demo_codebuild.arn

  artifacts {
    type     = "S3"
    location = aws_s3_bucket.demo_aws_codebuild_bucket_output.id
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/tungbq/aws-cicd-source-example.git"
    git_clone_depth = 1
  }

  source_version = "main"

  tags = {
    Environment = "Test"
  }
}
