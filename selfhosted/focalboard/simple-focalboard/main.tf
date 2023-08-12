provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "focalboard_instance" {
  # To get the AMI ID, visit: https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#AMICatalog
  ami           = "ami-0a0c8eebcdd6dcbd0" # Ubuntu 22.04
  instance_type = "t2.micro"

  user_data = file("${path.module}/scripts/install_app.sh")

  tags = {
    Name = "focalboard-instance"
  }
}
