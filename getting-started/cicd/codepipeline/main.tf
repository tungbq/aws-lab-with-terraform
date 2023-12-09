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

# Module: Codedeploy
module "codedeploy" {
  source                = "./modules/codedeploy"
  code_deploy_role_name = module.iam.code_deploy_role_name
}
