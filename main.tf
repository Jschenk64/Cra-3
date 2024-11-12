# VPC (aws_vpc.cra_3_vpc):

resource "aws_vpc" "cra_3_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.tags["vpc"]
  }
}

# Public Subnets (aws_subnet.cra_3_pub1 and aws_subnet.cra_3_pub2):

resource "aws_subnet" "cra_3_pub1" {
  vpc_id               = aws_vpc.cra_3_vpc.id
  cidr_block           = var.public_subnet_cidrs[0]
  availability_zone    = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = {
    Name = var.tags["public_sub1"]
  }
}

resource "aws_subnet" "cra_3_pub2" {
  vpc_id               = aws_vpc.cra_3_vpc.id
  cidr_block           = var.public_subnet_cidrs[1]
  availability_zone    = var.availability_zones[1]
  map_public_ip_on_launch = true

  tags = {
    Name = var.tags["public_sub2"]
  }
}

# Private Subnets (aws_subnet.cra_3_priv1 and aws_subnet.cra_3_priv2):

resource "aws_subnet" "cra_3_priv1" {
  vpc_id            = aws_vpc.cra_3_vpc.id
  cidr_block        = var.private_subnet_cidrs[0]
  availability_zone = var.availability_zones[0]
  
  tags = {
    Name = var.tags["private_sub1"]
  }
}

resource "aws_subnet" "cra_3_priv2" {
  vpc_id            = aws_vpc.cra_3_vpc.id
  cidr_block        = var.private_subnet_cidrs[1]
  availability_zone = var.availability_zones[1]
  
  tags = {
    Name = var.tags["private_sub2"]
  }
}

# Internet Gateway (aws_internet_gateway.cra_3_igw):

resource "aws_internet_gateway" "cra_3_igw" {
  vpc_id = aws_vpc.cra_3_vpc.id

  tags = {
    Name = var.tags["igw"]
  }
}

# Public Route Table (aws_route_table.cra_3_pub_rt):

resource "aws_route_table" "cra_3_pub_rt" {
  vpc_id = aws_vpc.cra_3_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cra_3_igw.id
  }

  tags = {
    Name = var.tags["pub_rt"]
  }

}

# Elastic IP (aws_eip.cra_3_eip):
# Allocates an Elastic IP, which will be used by the NAT gateway.

resource "aws_eip" "cra_3_eip" {
  
  tags = {
    Name = var.tags["eip"]
  }
}

# NAT Gateway (aws_nat_gateway.cra_3_nat_gw):

resource "aws_nat_gateway" "cra_3_nat_gw" {
  allocation_id = aws_eip.cra_3_eip.id
  subnet_id     = aws_subnet.cra_3_pub1.id

  tags = {
    Name = var.tags["nat_gw"]
  }
}

# Private Route Table (aws_route_table.cra_3_priv_rt):

resource "aws_route_table" "cra_3_priv_rt" {
  vpc_id = aws_vpc.cra_3_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.cra_3_nat_gw.id
  }

  tags = {
    Name = var.tags["priv_rt"]
  }
}

# Route Table Associations:

resource "aws_route_table_association" "cra_3_pub1" {
  subnet_id      = aws_subnet.cra_3_pub1.id
  route_table_id = aws_route_table.cra_3_pub_rt.id
}

resource "aws_route_table_association" "cra_3_pub2" {
  subnet_id      = aws_subnet.cra_3_pub2.id
  route_table_id = aws_route_table.cra_3_pub_rt.id
}

resource "aws_route_table_association" "cra_3_priv1" {
  subnet_id      = aws_subnet.cra_3_priv1.id
  route_table_id = aws_route_table.cra_3_priv_rt.id
}

resource "aws_route_table_association" "cra_3_priv2" {
  subnet_id      = aws_subnet.cra_3_priv2.id
  route_table_id = aws_route_table.cra_3_priv_rt.id
}

# Security Group (aws_security_group.cra_3_sg):
# Allows inbound SSH (port 22) and HTTP (port 80) traffic from any IP (0.0.0.0/0).

resource "aws_security_group" "cra_3_sg" {
  name        = "Allow Cra-3_sg"
  description = "Allow SSH, HTTP inbound Traffic"
  vpc_id      = aws_vpc.cra_3_vpc.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.tags["sg"]
  }
}

