output "public_ip" {
  value = aws_instance.focalboard_instance.public_ip
}

output "public_ip_dns" {
  value = aws_instance.focalboard_instance.public_dns
}
