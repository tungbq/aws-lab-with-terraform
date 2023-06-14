# t2.micro node with an AWS Tag naming it "HelloWorld"


resource "aws_instance" "app" {
  ami           = "ami-022e1a32d3f742bd8"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private_app_subnet_1a.id
  tags = {
    Name = "HelloWorld"
  }
}
