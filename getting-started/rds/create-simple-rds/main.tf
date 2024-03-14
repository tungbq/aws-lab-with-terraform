terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_db_instance" "basic_rds_instance" {
  engine            = "mysql"
  allocated_storage = 20
  instance_class    = "db.t2.micro"
  engine_version    = "5.7"
  db_name           = "my_rds_instance"
  username          = "root"
  password          = "password"

  tags = {
    Name        = "MyRDSInstance" # Adding tags for better organization
    Environment = "Dev"           # Example tag, adjust as needed
  }

  # Optional: Configure backup retention period, multi AZ deployment, and deletion protection
  backup_retention_period = 7     # Retain backups for 7 days
  multi_az                = false # Enable multi-AZ deployment for high availability
  deletion_protection     = true  # Prevent accidental deletion of the RDS instance
}
