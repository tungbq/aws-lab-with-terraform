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
data "archive_file" "source_demo_app" {
  type        = "zip"
  source_dir  = "./demo_app/"
  output_path = "./demo_app_zip/MessageUtil.zip"
}

# Uploading to S3
resource "aws_s3_object" "file_upload" {
  bucket      = aws_s3_bucket.demo_aws_codebuild_bucket_input.id
  key         = "MessageUtil.zip"
  source = data.archive_file.source_demo_app.output_path
  # Use the object etag to let Terraform recognize when the content has changed, regardless of the local filename or object path
  etag = filemd5(data.archive_file.source_demo_app.output_path)
}
