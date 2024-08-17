# ec2.tf

resource "aws_instance" "web_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.web_sg.id]
  user_data     = file("${path.module}/scripts/web.sh")

  tags = {
    Name = "${var.app_name}-web-instance"
  }
}

resource "aws_instance" "app_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private_subnet.id
  security_groups = [aws_security_group.app_sg.id]
  user_data     = file("${path.module}/scripts/app.sh")

  tags = {
    Name = "${var.app_name}-app-instance"
  }
}

resource "aws_instance" "db_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private_subnet.id
  security_groups = [aws_security_group.db_sg.id]
  user_data     = file("${path.module}/scripts/db.sh")

  tags = {
    Name = "${var.app_name}-db-instance"
  }
}
