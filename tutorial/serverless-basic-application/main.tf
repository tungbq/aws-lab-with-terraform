provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

resource "aws_amplify_app" "demo_web" {
  name       = "demo_web"
  repository = "https://github.com/tungbq/source-serverless-basic-application"

  # GitHub personal access token
  access_token = var.token

  enable_auto_branch_creation = true
  enable_branch_auto_build = true
  enable_branch_auto_deletion = true


  # The default patterns added by the Amplify Console.
  auto_branch_creation_patterns = [
    "*",
    "*/**",
  ]

  auto_branch_creation_config {
    # Enable auto build for the created branch.
    enable_auto_build = true
  }

  build_spec = <<-EOT
    version: 1
    frontend:
      phases:
        pre_build:
          commands:
            - echo "Pre-build command"
        build:
          commands:
            - echo "Build command"
        post_build:
          commands:
            - echo "Post-build command"
      artifacts:
        baseDirectory: /
        files:
          - '**/*'
      cache:
        paths: []
  EOT

  # The default rewrites and redirects added by the Amplify Console.
  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }

  environment_variables = {
    ENV = "test"
  }
}
