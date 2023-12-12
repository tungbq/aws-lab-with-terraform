# Set AWS Provider
provider "aws" {
  region = "us-east-1" # Replace with your desired region
}


# Module: S3 Bucket Creation
module "s3_bucket" {
  source      = "./modules/s3_bucket"
  bucket_name = "tungbq-demo-codepipeline-bucket"
}


# Module: Launch EC2 instance and install code deploy on it
module "iam" {
  source = "./modules/iam"
}

# Module: Launch EC2 instance and install code deploy on it
module "ec2_codedeploy" {
  source       = "./modules/ec2_codedeploy"
  profile_name = module.iam.profile_name
}

# Module: Codedeploy
module "codedeploy" {
  source           = "./modules/codedeploy"
  service_role_arn = module.iam.service_role_arn
}


# Module: Codepipeline
module "codepipeline" {
  source        = "./modules/codepipeline"
  s3_bucket_id  = module.s3_bucket.bucket_id
  s3_bucket_arn = module.s3_bucket.bucket_arn
}
