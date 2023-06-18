provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

resource "aws_s3_bucket" "sample_s3_bucket" {
  bucket = "sample-s3-tf"

  tags = {
    Name        = "S3 bucket to store code"
    Environment = "Dev"
  }
}
