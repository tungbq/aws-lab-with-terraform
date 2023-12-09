# modules/codebuild_project/main.tf
resource "aws_codebuild_project" "demo_project" {
  name           = var.project_name
  description    = "Demo project"
  build_timeout  = 5
  queued_timeout = 5

  service_role = var.service_role

  artifacts {
    type     = "S3"
    location = var.s3_bucket_id
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/tungbq/aws-cicd-source-example.git"
    git_clone_depth = 1
  }

  source_version = "main"

  tags = {
    Environment = "Test"
  }
}
