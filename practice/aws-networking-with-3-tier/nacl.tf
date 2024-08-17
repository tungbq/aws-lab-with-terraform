# nacl.tf

resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.custom_vpc.id

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "${var.app_name}-public-nacl"
  }
}

resource "aws_network_acl" "private_nacl" {
  vpc_id = aws_vpc.custom_vpc.id

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "${var.app_name}-private-nacl"
  }
}

resource "aws_network_acl_association" "public_nacl_assoc" {
  subnet_id = aws_subnet.public_subnet.id
  network_acl_id = aws_network_acl.public_nacl.id
}

resource "aws_network_acl_association" "private_nacl_assoc" {
  subnet_id = aws_subnet.private_subnet.id
  network_acl_id = aws_network_acl.private_nacl.id
}
