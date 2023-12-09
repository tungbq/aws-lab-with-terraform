# modules/codebuild_project/variables.tf
variable "project_name" {
  description = "Name of the CodeBuild project"
  type        = string
}

variable "service_role" {
  description = "ARN of the service role for CodeBuild"
  type        = string
}

variable "s3_bucket_id" {
  description = "ID of the S3 bucket"
  type        = string
}
