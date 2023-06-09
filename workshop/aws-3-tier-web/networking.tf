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
## Eastic IP first:
resource "aws_eip" "nat_gateway_eip_1a" {
  domain = "vpc"
}

resource "aws_nat_gateway" "public_web_subnet_1a_nat" {
  subnet_id     = aws_subnet.nat_gateway_eip_1a.id
  allocation_id = aws_eip.nat_gateway_eip.id

  tags = {
    Name = "gw NAT AZ 1A"
  }
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.three_tier_igw]
}
