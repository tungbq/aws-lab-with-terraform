
resource "aws_instance" "basic_ec2_instance" {
  # To get the AMI ID, visit: https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#AMICatalog
  ami           = "ami-0f34c5ae932e6f0e4"
  instance_type = "t2.micro"

  iam_instance_profile = var.profile_name

  tags = {
    Name = "MyCodePipelineDemo"
  }
}
