variable "service_role_arn" {
  description = "ARN of the IAM profile"
  type        = string
}

variable "deployment_group_name" {
  description = "Name of the deployment group"
  type        = string
  default     = "demo-deployment-group"
}

variable "deployment_config_name" {
  description = "Name of the deployment configuration"
  type        = string
  default     = "demo-deployment-config"
}

variable "codedeploy_app_name" {
  description = "Name of the codedeploy app"
  type        = string
  default     = "demo-codedeploy-app"
}

variable "ec2_tag_filter_name" {
  description = "Name of the EC2 tag"
  type        = string
  default     = "MyCodePipelineDemo"
}
