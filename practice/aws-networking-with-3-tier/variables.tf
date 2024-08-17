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

variable "ami_id" {
  description = "AMI ID"
  type        = string
  default     = "ami-12345678"
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}
