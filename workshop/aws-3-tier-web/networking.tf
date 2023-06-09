##### VPC creation
resource "aws_vpc" "workshop_aws_3_tier_vpc" {
  cidr_block = "10.0.0.0/16"
}


### Web tier subnets
resource "aws_subnet" "public_web_subnet_1a" {
  vpc_id                  = aws_vpc.workshop_aws_3_tier_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a" # Replace with your desired availability zone

  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Web-Subnet-AZ-1A"
  }
}

resource "aws_subnet" "public_web_subnet_1b" {
  vpc_id                  = aws_vpc.workshop_aws_3_tier_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b" # Replace with your desired availability zone

  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Web-Subnet-AZ-1B"
  }
}


### App tier subnets
resource "aws_subnet" "private_app_subnet_1a" {
  vpc_id                  = aws_vpc.workshop_aws_3_tier_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1a" # Replace with your desired availability zone

  map_public_ip_on_launch = true

  tags = {
    Name = "Private-App-Subnet-AZ-1A"
  }
}

resource "aws_subnet" "private_app_subnet_1b" {
  vpc_id                  = aws_vpc.workshop_aws_3_tier_vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-1b" # Replace with your desired availability zone

  map_public_ip_on_launch = true

  tags = {
    Name = "Private-App-Subnet-AZ-1B"
  }
}


### DB tier subnets
resource "aws_subnet" "private_db_subnet_1a" {
  vpc_id                  = aws_vpc.workshop_aws_3_tier_vpc.id
  cidr_block              = "10.0.5.0/24"
  availability_zone       = "us-east-1a" # Replace with your desired availability zone

  map_public_ip_on_launch = true

  tags = {
    Name = "Private-DB-Subnet-AZ-1A"
  }
}

resource "aws_subnet" "private_db_subnet_1b" {
  vpc_id                  = aws_vpc.workshop_aws_3_tier_vpc.id
  cidr_block              = "10.0.6.0/24"
  availability_zone       = "us-east-1b" # Replace with your desired availability zone

  map_public_ip_on_launch = true

  tags = {
    Name = "Private-DB-Subnet-AZ-1B"
  }
}


# part01/internetconnectivity
resource "aws_internet_gateway" "three_tier_igw" {
  vpc_id = aws_vpc.workshop_aws_3_tier_vpc.id

  tags = {
    Name = "3tier IGW"
  }
}



# NAT GW (on public)
# NAT GW on AZ 1A
## Eastic IP first
resource "aws_eip" "nat_gateway_eip_1a" {
  domain = "vpc"
}
resource "aws_nat_gateway" "public_web_subnet_1a_nat" {
  subnet_id     = aws_subnet.public_web_subnet_1a.id
  allocation_id = aws_eip.nat_gateway_eip_1a.id

  tags = {
    Name = "NAT Gateway AZ 1A"
  }
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.three_tier_igw]
}

# NAT GW on AZ 1B
## Eastic IP first
resource "aws_eip" "nat_gateway_eip_1b" {
  domain = "vpc"
}
resource "aws_nat_gateway" "public_web_subnet_1b_nat" {
  subnet_id     = aws_subnet.public_web_subnet_1b.id
  allocation_id = aws_eip.nat_gateway_eip_1b.id

  tags = {
    Name = "NAT Gateway AZ 1B"
  }
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.three_tier_igw]
}

### Route table
## Public
resource "aws_route_table" "public_web_rt" {
  vpc_id = aws_vpc.workshop_aws_3_tier_vpc.id

  # Allowing public IP to comunicate with IGW
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.three_tier_igw.id
  }

  tags = {
    Name = "public_web_rt"
  }
}

# association pub subnet 1A 1B
resource "aws_route_table_association" "rt_to_public_web_subnet_1a" {
  subnet_id      = aws_subnet.public_web_subnet_1a.id
  route_table_id = aws_route_table.public_web_rt.id
}

resource "aws_route_table_association" "rt_to_public_web_subnet_1b" {
  subnet_id      = aws_subnet.public_web_subnet_1b.id
  route_table_id = aws_route_table.public_web_rt.id
}


# private
## private 1A
resource "aws_route_table" "private_rt_az_1a" {
  vpc_id = aws_vpc.workshop_aws_3_tier_vpc.id

  # Allowing public IP to comunicate with NAT Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.public_web_subnet_1a_nat.id
  }

  tags = {
    Name = "private_rt_az_1a"
  }
}

# association pub subnet 1A 1B
resource "aws_route_table_association" "rt_to_private_web_subnet_1a" {
  subnet_id      = aws_subnet.private_app_subnet_1a.id
  route_table_id = aws_route_table.private_rt_az_1a.id
}

## private 1B
resource "aws_route_table" "private_rt_az_1b" {
  vpc_id = aws_vpc.workshop_aws_3_tier_vpc.id

  # Allowing public IP to comunicate with NAT Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.public_web_subnet_1b_nat
  }

  tags = {
    Name = "private_rt_az_1b"
  }
}

# association pub subnet 1A 1B
resource "aws_route_table_association" "rt_to_private_web_subnet_1b" {
  subnet_id      = aws_subnet.private_app_subnet_1b.id
  route_table_id = aws_route_table.private_rt_az_1b.id
}

