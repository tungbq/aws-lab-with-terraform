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

# Authentication
data "aws_secretsmanager_secret" "github_token" {
  name = "GitHubToken" # Replace with your secret name in Secrets Manager
}

# resource "aws_codebuild_webhook" "example" {
#   project_name = aws_codebuild_project.demo_project.name
# }

# resource "github_repository_webhook" "example" {
#   active     = true
#   events     = ["push"]
#   name       = "example"
#   repository = github_repository.example.name

#   configuration {
#     url          = aws_codebuild_webhook.example.payload_url
#     secret       = aws_codebuild_webhook.example.secret
#     content_type = "json"
#     insecure_ssl = false
#   }
# }

### CODE BUILD PROJECT
resource "aws_codebuild_project" "demo_project" {
  name           = "test-project-cache"
  description    = "test_codebuild_project_cache"
  build_timeout  = 5
  queued_timeout = 5

  service_role = aws_iam_role.example.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "GITHUB_AUTH_TOKEN"
      value = data.aws_secretsmanager_secret.github_token.secret_string
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/tungbq/aws-cicd-source-example.git"
    git_clone_depth = 1
  }

  tags = {
    Environment = "Test"
  }
}