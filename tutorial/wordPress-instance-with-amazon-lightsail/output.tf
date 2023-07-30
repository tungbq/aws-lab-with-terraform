output "public_ip_address" {
  description = "Public IP address of the Instance"
  value = aws_lightsail_instance.wordpress.public_ip_address
}

output "username" {
  description = "Username to connect to the Instance (not webpage)"
  value = aws_lightsail_instance.wordpress.username
}
