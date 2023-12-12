
resource "aws_instance" "basic_ec2_instance" {
  # To get the AMI ID, visit: https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#AMICatalog
  ami           = "ami-0f34c5ae932e6f0e4"
  instance_type = "t2.micro"

  iam_instance_profile = var.profile_name
  security_groups      = [aws_security_group.ec2_codedeploy.name]

  user_data = file("${path.module}/scripts/install_codedeploy.sh")
  tags = {
    Name = "MyCodePipelineDemo"
  }
}

resource "aws_security_group" "ec2_codedeploy" {
  name        = "ec2-codedeploy-security-group"
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

# resource "null_resource" "install_codedeploy" {
#   provisioner "remote-exec" {
#     inline = [
#       "chmod +x /path/to/your/install_codedeploy_agent.sh",
#       "/path/to/your/install_codedeploy_agent.sh"
#     ]

#     connection {
#       type        = "ssh"
#       user        = "ec2-user" # or your SSH user
#       private_key = file("/path/to/your/private_key.pem")
#       host        = aws_instance.example.public_ip # or your instance's public IP
#     }
#   }

#   depends_on = [aws_instance.basic_ec2_instance]
# }
