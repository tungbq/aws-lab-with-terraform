provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

resource "aws_s3_bucket" "tungbq_s3_website" {
  bucket = "tungbq-s3-website"

  tags = {
    Name        = "S3 bucket to store website"
    Environment = "Dev"
  }
}
