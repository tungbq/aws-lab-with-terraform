provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

resource "aws_amplify_app" "example" {
  name       = "example"
  repository = "https://github.com/tungbq/source-serverless-basic-application"

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
