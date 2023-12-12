# modules/s3_bucket/main.tf
resource "aws_s3_bucket" "demo_aws_codebuild_bucket_output" {
  bucket = var.bucket_name

  force_destroy = true
}

output "bucket_arn" {
  value = aws_s3_bucket.demo_aws_codebuild_bucket_output.arn
}

output "bucket_id" {
  value = aws_s3_bucket.demo_aws_codebuild_bucket_output.id
}
