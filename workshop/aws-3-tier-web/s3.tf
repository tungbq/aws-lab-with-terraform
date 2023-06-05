provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

resource "aws_s3_bucket" "tungbq_app_code" {
  bucket = "tungbq-app-code"

  tags = {
    Name        = "S3 bucket to store code"
    Environment = "Dev"
  }
}
