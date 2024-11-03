provider "aws" {
  region = "eu-central-1"
}

resource "aws_vpc" "cra_vpc" {
  cidr_block           = "10.150.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "CRA-VPC"
  }
}

resource "aws_subnet" "cra_pub_subnet1" {
  vpc_id                  = aws_vpc.cra_vpc.id
  cidr_block              = "10.150.10.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "CRA-pub-subnet1"
  }
}

resource "aws_subnet" "cra_pub_subnet2" {
  vpc_id                  = aws_vpc.cra_vpc.id
  cidr_block              = "10.150.20.0/24"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "CRA-pub-subnet2"
  }
}

resource "aws_internet_gateway" "cra_igw" {
  vpc_id = aws_vpc.cra_vpc.id

  tags = {
    Name = "CRA-IGW"
  }
}

resource "aws_route_table" "cra_pub_rt" {
  vpc_id = aws_vpc.cra_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cra_igw.id
  }

  tags = {
    Name = "CRA-PUB-RT"
  }
}

resource "aws_route_table_association" "pub_subnet1_assoc" {
  subnet_id      = aws_subnet.cra_pub_subnet1.id
  route_table_id = aws_route_table.cra_pub_rt.id
}

resource "aws_route_table_association" "pub_subnet2_assoc" {
  subnet_id      = aws_subnet.cra_pub_subnet2.id
  route_table_id = aws_route_table.cra_pub_rt.id
}

resource "aws_security_group" "cra_sg" {
  name        = "allow_cra_sg"
  description = "Allow SSH, HTTP inbound traffic"
  vpc_id      = aws_vpc.cra_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "CRA-SG"
  }
}

resource "aws_instance" "cra_web1" {
  ami                    = "ami-08ec94f928cf25a9d"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.cra_pub_subnet1.id
  key_name               = "mse-svh105"
  vpc_security_group_ids = [aws_security_group.cra_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo su
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1> This is my journey to Devops $(hostname -f) in AZ $EC2_AVAIL_ZONE </h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "CRA-Web1"
  }
}


resource "aws_instance" "cra_web2" {
  ami                    = "ami-08ec94f928cf25a9d"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.cra_pub_subnet2.id
  key_name               = "mse-svh105"
  vpc_security_group_ids = [aws_security_group.cra_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo su
              yum update -y
              yum install -y nginx
              systemctl start nginx
              systemctl enable nginx
              EOF

  tags = {
    Name = "CRA-Web2"
  }
}

resource "aws_lb" "cra_lb1" {
  name               = "CRA-LB1"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.cra_sg.id]
  subnets            = [aws_subnet.cra_pub_subnet1.id, aws_subnet.cra_pub_subnet2.id]

  tags = {
    Name = "CRA-LB1"
  }
}

resource "aws_lb_target_group" "cra_target1" {
  name     = "CRA-Target1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.cra_vpc.id

  tags = {
    Name = "CRA-Target1"
  }
}

# Registering instances with the target group
resource "aws_lb_target_group_attachment" "cra_web1_attachment" {
  target_group_arn = aws_lb_target_group.cra_target1.arn
  target_id        = aws_instance.cra_web1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "cra_web2_attachment" {
  target_group_arn = aws_lb_target_group.cra_target1.arn
  target_id        = aws_instance.cra_web2.id
  port             = 80
}

# Creating a listener for the load balancer
resource "aws_lb_listener" "cra_listener" {
  load_balancer_arn = aws_lb.cra_lb1.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cra_target1.arn
  }
}
