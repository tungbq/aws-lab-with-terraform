# Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
# t2.micro node with an AWS Tag naming it "AppLayer"


resource "aws_instance" "app" {
  ami           = "ami-090e0fc566929d98b" # AMI with SSM preinstalled
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private_app_subnet_1a.id
  iam_instance_profile = aws_iam_instance_profile.ec2_role_for_s3_ssm_profile.name

  security_groups = [aws_security_group.app_tier_sg.id]

  tags = {
    Name = "AppLayer"
  }
}
