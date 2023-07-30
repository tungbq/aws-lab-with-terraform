# Create a new Wordpress Lightsail Instance
resource "aws_lightsail_instance" "wordpress" {
  name              = "wordpress-demo"
  availability_zone = "us-east-1b"
  blueprint_id      = "wordpress"
  bundle_id         = "nano_1_0"
  tags = {
    type = "wordpress"
  }
}
