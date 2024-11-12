resource "aws_vpc" "cra-3_vpc" {
  cidr_block       = "10.150.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true


  tags = {
    Name = "Cra-3-VPC"
  }
}

resource "aws_subnet" "cra-3_pub1" {
  vpc_id     = aws_vpc.cra-3_vpc.id
  cidr_block = "10.150.10.0/24"
  availability_zone = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Cra-3-Pub1"
  }
}

resource "aws_subnet" "cra-3_pub2" {
  vpc_id     = aws_vpc.cra-3_vpc.id
  cidr_block = "10.150.11.0/24"
  availability_zone = "eu-central-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Cra-3-Pub2"
  }
}

resource "aws_subnet" "cra-3_priv1" {
  vpc_id     = aws_vpc.cra-3_vpc.id
  cidr_block = "10.150.12.0/24"
  availability_zone = "eu-central-1a"
  
  tags = {
    Name = "Cra-3-Priv1"
  }
}

resource "aws_subnet" "cra-3_priv2" {
  vpc_id     = aws_vpc.cra-3_vpc.id
  cidr_block = "10.150.13.0/24"
  availability_zone = "eu-central-1b"
  
  tags = {
    Name = "Cra-3-Priv2"
  }
}

resource "aws_internet_gateway" "Cra-3_igw" {
  vpc_id = aws_vpc.cra-3_vpc.id

  tags = {
    Name = "Cra-3-IGW"
  }
}

resource "aws_route_table" "cra-3_pub_rt" {
  vpc_id = aws_vpc.cra-3_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Cra-3_igw.id
  }

  
  tags = {
    Name = "Cra-3_Pub_RT"
  }
}

resource "aws_route_table" "cra-3_priv_rt" {
  vpc_id = aws_vpc.cra-3_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Cra-3_igw.id
  }

  
  tags = {
    Name = "Cra-3_Priv_RT"
  }
}

resource "aws_route_table_association" "cra-3_pub1" {
  subnet_id      = aws_subnet.cra-3_pub1.id
  route_table_id = aws_route_table.cra-3_pub_rt.id
}

resource "aws_route_table_association" "cra-3_pub2" {
  subnet_id      = aws_subnet.cra-3_pub2.id
  route_table_id = aws_route_table.cra-3_pub_rt.id
}

resource "aws_route_table_association" "cra-3_priv1" {
  subnet_id      = aws_subnet.cra-3_priv1.id
  route_table_id = aws_route_table.cra-3_priv_rt.id
}

resource "aws_route_table_association" "cra-3_priv2" {
  subnet_id      = aws_subnet.cra-3_priv2.id
  route_table_id = aws_route_table.cra-3_priv_rt.id
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_security_group" "cra-3_sg" {
  name = "Allow Cra-3_sg"
  description = "Allow SSH, HTTP inbound Traffic"
  vpc_id = aws_vpc.cra-3_vpc.id
  
  

  egress {
    description = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  egress {
    description = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
        from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "CRA-3-SG"
  }
}


resource "aws_eip" "cra-3_eip" {
  vpc = true

  tags = {
    Name = "CRA-3_EIP"
  }
}

resource "aws_nat_gateway" "cra-3_nat_gw" {
  allocation_id = aws_eip.cra-3_eip.id
  subnet_id     = aws_subnet.cra-3_pub1.id

  tags = {
    Name = "Cra-3_NAT_GW"
  }
  
}

