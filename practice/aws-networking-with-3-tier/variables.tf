# variables.tf

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-west-2"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR block"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR block"
  type        = string
  default     = "10.0.2.0/24"
}

variable "app_name" {
  description = "Application Name"
  type        = string
  default     = "myapp"
}

# Check AMI at: https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#AMICatalog
## Ubuntu 22.04: ami-0a0e5d9c7acc336f1
variable "ami_id" {
  description = "AMI ID"
  type        = string
  default     = "ami-0a0e5d9c7acc336f1"
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}
