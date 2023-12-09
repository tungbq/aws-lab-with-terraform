# Set AWS Provider
provider "aws" {
  region = "us-east-1" # Replace with your desired region
}

# Module: S3 Bucket Creation
module "s3_bucket" {
  source = "./modules/s3_bucket"

  bucket_name = "tungbq-demo-aws-codebuild-bucket-output"
  tags = {
    Name        = "S3 bucket to store output code"
    Environment = "Dev"
  }
}

# Module: IAM Role Creation
module "iam_role" {
  source = "./modules/iam_role"

  service_name = "codebuild.amazonaws.com"
}

# Module: IAM Role Policy Creation
module "iam_role_policy" {
  source = "./modules/iam_role_policy"

  role_name     = module.iam_role.role_name
  s3_bucket_arn = module.s3_bucket.bucket_arn
}

# Module: CodeBuild Project Creation
module "codebuild_project" {
  source = "./modules/codebuild_project"

  project_name = "demo_project"
  service_role = module.iam_role.role_arn
  s3_bucket_id = module.s3_bucket.bucket_id
}
