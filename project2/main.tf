terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.2.0"
    }
  }
}
provider "aws" {
  region = "ap-south-1"
}

# VPC: A VPC with a CIDR block of 10.0.0.0/16.
resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my-vpc"
  }
}

# One public subnet with a CIDR block of 10.0.1.0/24.
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "my-vpc-public_subnet"
  }
}

# One private subnet with a CIDR block of 10.0.2.0/24.
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "my-vpc-private_subnet"
  }
}
# One Internet Gateway.
resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "my-igw"
  }
}

#One public route table with a route to the Internet Gateway,



resource "aws_route_table" "my-rt" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }
  tags = {
    Name = "my-rt"
  }

}
#correct association between the public subnet and the public route table.
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.my-rt.id
}

resource "aws_security_group" "httpd-sg" {
  vpc_id = aws_vpc.my-vpc.id
  #inbound rule
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  #outbound rule
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
tags = {
    Name = "httpd-sg"
}
}

#create ec2 instance
resource "aws_instance" "httpdserver" {
  ami           = "ami-0d03cb826412c6b0f"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  security_groups = [aws_security_group.httpd-sg.id]
  user_data     = <<-EOF
    #!/bin/bash
    dnf install httpd -y
    systemctl enable --now httpd
    echo "<h1>Hello, World!</h1>" > /var/www/html/index.html
    EOF
  tags = {
    Name = "httpdserver"
  }
}




# output private ip of ec2 instance
output "private_ip" {
  value = aws_instance.httpdserver.public_ip
}
output "APP_URL" {
  value = "http://${aws_instance.httpdserver.public_ip}"
}
