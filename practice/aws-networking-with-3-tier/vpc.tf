# vpc.tf

resource "aws_vpc" "custom_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.app_name}-vpc"
  }
}

output "vpc_id" {
  value = aws_vpc.custom_vpc.id
}
