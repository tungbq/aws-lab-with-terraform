# t2.micro node with an AWS Tag naming it "HelloWorld"


resource "aws_instance" "app" {
  ami           = "ami-022e1a32d3f742bd8"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private_app_subnet_1a.id
  aws_iam_instance_profile = aws_iam_role.ec2_role_for_s3_ssm.name

  security_groups = [aws_security_group.app_tier_sg.id]

  tags = {
    Name = "AppLayer"
  }
}
