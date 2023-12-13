variable "s3_bucket_id" {
  description = "ID of the S3 bucket"
  type        = string
}

variable "s3_bucket_arn" {
  description = "The ARN for the S3 bucket"
  type        = string
}

variable "codepipeline_name" {
  description = "Code pipeline name"
  type        = string
  default     = "tf-demo-codepipeline"
}

variable "github_repo_name" {
  description = "Github repository naming"
  type        = string
  default     = "tungbq/aws-codepipeline-demo"
}

variable "aws_codestarconnections_connection_name" {
  description = "Codestar connection naming"
  type        = string
  default     = "demo-codepipeline-connection"
}
