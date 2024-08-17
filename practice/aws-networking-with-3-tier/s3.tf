# s3.tf

resource "aws_s3_bucket" "app_bucket" {
  bucket = "aws-networking-with-3-tier-${var.app_name}-bucket"

  tags = {
    Name = "${var.app_name}-bucket"
  }
}

output "s3_bucket_name" {
  value = aws_s3_bucket.app_bucket.bucket
}
