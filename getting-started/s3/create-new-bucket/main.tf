provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

resource "aws_s3_bucket" "tungbq_sample_s3_bucket" {
  bucket = "tungbq_sample_s3_bucket"

  tags = {
    Name        = "S3 bucket to store code"
    Environment = "Dev"
  }
}
