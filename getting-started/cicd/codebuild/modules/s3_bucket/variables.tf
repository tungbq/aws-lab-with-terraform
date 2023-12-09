# modules/s3_bucket/variables.tf
variable "bucket_name" {
  description = "The name for the S3 bucket"
  type        = string
}

variable "tags" {
  description = "Tags for the S3 bucket"
  type        = map(string)
}
