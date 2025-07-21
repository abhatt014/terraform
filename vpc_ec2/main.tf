# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "6.2.0"
#     }
#   }
# }
# provider "aws" {
#   region = "ap-south-1"
# }

# # VPC: A VPC with a CIDR block of 10.0.0.0/16.
# resource "aws_vpc" "my-vpc" {
#   cidr_block = "10.0.0.0/16"
# }

# # One public subnet with a CIDR block of 10.0.1.0/24.
# resource "aws_subnet" "public_subnet" {
#   vpc_id     = aws_vpc.my-vpc.id
#   cidr_block = "10.0.1.0/24"

#   tags = {
#     Name = "public_subnet"
#   }
# }

# # One private subnet with a CIDR block of 10.0.2.0/24.
# resource "aws_subnet" "private_subnet" {
#   vpc_id     = aws_vpc.my-vpc.id
#   cidr_block = "10.0.2.0/24"

#   tags = {
#     Name = "private_subnet"
#   }
# }
# # One Internet Gateway.
# resource "aws_internet_gateway" "my-igw" {
#   vpc_id = aws_vpc.my-vpc.id

#   tags = {
#     Name = "myinternetgateway"
#   }
# }

# #One public route table with a route to the Internet Gateway,



# resource "aws_route_table" "my-rt" {
#   vpc_id = aws_vpc.my-vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.my-igw.id
#   }

# }
# #correct association between the public subnet and the public route table.
# resource "aws_route_table_association" "a" {
#   subnet_id      = aws_subnet.public_subnet.id
#   route_table_id = aws_route_table.my-rt.id
# }

# #create ec2 instance
# resource "aws_instance" "nginx" {
#   ami           = "ami-00c8ac9147e19828e"
#   instance_type = "t3.micro"
#   subnet_id     = aws_subnet.public_subnet.id
#   tags = {
#     name = "nginx-1"
#   }
# }

# # resource "aws_security_group" "nginx-sg" {
# #   vpc_id = aws_vpc.my-vpc.id
# #   #inbound rule
# #   ingress {
# #     protocol    = "tcp"
# #     from_port   = 80
# #     to_port     = 80
# #     cidr_blocks = ["0.0.0.0/0"]
# #   }
# #   #outbound rule
# #   egress {
# #     protocol    = "-1"
# #     from_port   = 0
# #     to_port     = 0
# #     cidr_blocks = ["0.0.0.0/0"]
# #   }
# # tags = {
# #     name = nginx-sg
# # }
# #}


# #
# userdata = <<=EOF
#     #!/bin/bash
#     yum update -y
#     yum install nginx -y
#     systemctl start nginx
#     systemctl enable nginx

#     service nginx restart
#     EOF

# # associate_public_ip_address = true
# #
# # output "public_ip" { 
# #   value = aws_instance.nginx.public_ip
# # }
# # output "public_url" { 
# #   value = "http://${aws_instance.nginx.public_ip}"
# # }