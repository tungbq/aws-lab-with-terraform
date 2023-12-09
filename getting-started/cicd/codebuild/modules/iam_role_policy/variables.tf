# modules/iam_role_policy/variables.tf
variable "role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  type        = string
}
