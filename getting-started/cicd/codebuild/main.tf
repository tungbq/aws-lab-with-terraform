provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

# Create 2 S3 buckets
resource "aws_s3_bucket" "demo_aws_codebuild_bucket_input" {
  bucket = "tungbq-demo-aws-codebuild-bucket-input"

  tags = {
    Name        = "S3 bucket to store input code"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket" "demo_aws_codebuild_bucket_output" {
  bucket = "tungbq-demo-aws-codebuild-bucket-output"

  tags = {
    Name        = "S3 bucket to store output code"
    Environment = "Dev"
  }
}

# Zip the code on the fly
data "archive_file" "source" {
  type        = "zip"
  source_dir  = "./demo_app/"
  output_path = "./demo_app_zip/MessageUtil.zip"
}