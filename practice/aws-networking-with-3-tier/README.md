# AWS networking with 3 tier web app

## Structure

```bash
# VPC Configuration
source = "./vpc.tf"

# Subnets Configuration
source = "./subnets.tf"

# NACL Configuration
source = "./nacl.tf"

# Security Groups Configuration
source = "./security_groups.tf"

# EC2 Instances Configuration (Web/App/DB)
source = "./ec2.tf"

# S3 Bucket Configuration
source = "./s3.tf"

# IAM Role Configuration
source = "./iam.tf"
```

## TF init

```bash
terraform init
```

## TF plan out

## TF apply
