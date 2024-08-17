# nacl.tf

# NACL for the Web Tier
resource "aws_network_acl" "web_nacl" {
  vpc_id = aws_vpc.custom_vpc.id

  # Outbound rules (allow all outbound traffic)
  egress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  # Inbound rules (allow HTTP and HTTPS traffic)
  ingress {
    rule_no    = 100
    protocol   = "6"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    rule_no    = 110
    protocol   = "6"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  tags = {
    Name = "${var.app_name}-web-nacl"
  }
}

# NACL for the App Tier
resource "aws_network_acl" "app_nacl" {
  vpc_id = aws_vpc.custom_vpc.id

  # Outbound rules (allow all outbound traffic)
  egress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  # Inbound rules (allow traffic on port 8080 from the web subnet)
  ingress {
    rule_no    = 100
    protocol   = "6"
    action     = "allow"
    cidr_block = aws_subnet.public_subnet.cidr_block
    from_port  = 8080
    to_port    = 8080
  }

  tags = {
    Name = "${var.app_name}-app-nacl"
  }
}

# NACL for the Database Tier
resource "aws_network_acl" "db_nacl" {
  vpc_id = aws_vpc.custom_vpc.id

  # Outbound rules (allow all outbound traffic)
  egress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  # Inbound rules (allow traffic on port 5432 from the app subnet)
  ingress {
    rule_no    = 100
    protocol   = "6"
    action     = "allow"
    cidr_block = aws_subnet.private_subnet.cidr_block
    from_port  = 5432
    to_port    = 5432
  }

  tags = {
    Name = "${var.app_name}-db-nacl"
  }
}

# Associating NACLs with Subnets
resource "aws_network_acl_association" "web_nacl_assoc" {
  subnet_id     = aws_subnet.public_subnet.id
  network_acl_id = aws_network_acl.web_nacl.id
}

resource "aws_network_acl_association" "app_nacl_assoc" {
  subnet_id     = aws_subnet.private_subnet.id
  network_acl_id = aws_network_acl.app_nacl.id
}

resource "aws_network_acl_association" "db_nacl_assoc" {
  subnet_id     = aws_subnet.private_subnet.id
  network_acl_id = aws_network_acl.db_nacl.id
}
