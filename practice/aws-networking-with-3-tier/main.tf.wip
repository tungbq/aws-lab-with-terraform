# main.tf

provider "aws" {
  region = var.aws_region
}

# Include the individual component files
# terraform {
#   source = "./"
# }

# VPC Configuration
module "vpc" {
  source = "./vpc.tf"
}

# Subnets Configuration
module "subnets" {
  source = "./subnets.tf"
}

# NACL Configuration
module "nacl" {
  source = "./nacl.tf"
}

# Security Groups Configuration
module "security_groups" {
  source = "./security_groups.tf"
}

# EC2 Instances Configuration
module "ec2" {
  source = "./ec2.tf"
}

# S3 Bucket Configuration
module "s3" {
  source = "./s3.tf"
}

# IAM Role Configuration
module "iam" {
  source = "./iam.tf"
}
