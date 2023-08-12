provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "focalboard_instance" {
  # To get the AMI ID, visit: https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#AMICatalog
  ami           = "ami-0261755bbcb8c4a84" # Ubuntu 20.04
  instance_type = "t2.micro"

  security_groups = [aws_security_group.focalboard_sg.name]

  user_data = file("${path.module}/scripts/install_app.sh")

  tags = {
    Name = "focalboard-instance"
  }
}

resource "aws_security_group" "focalboard_sg" {
  name        = "focalboard-security-group"
  description = "Focalboard security group allowing ports 22 and 80"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
