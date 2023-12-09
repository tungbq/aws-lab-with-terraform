# Set AWS Provider
provider "aws" {
  region = "us-east-1" # Replace with your desired region
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
