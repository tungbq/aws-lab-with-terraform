variable "profile_name" {
  description = "Name of the IAM profile"
  type        = string
}

variable "ec2_tag_name" {
  description = "Name of the EC2 tag"
  type        = string
  default     = "MyCodePipelineDemo"
}

variable "ec2_codedeploy_sg_name" {
  description = "ec2-codedeploy-security-group"
  type        = string
  default     = "ec2-codedeploy-security-group"
}
