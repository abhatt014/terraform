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

data "aws_ami" "image" {
most_recent = true
owners = ["amazon"]
}


#create ec2 instance
resource "aws_instance" "httpdserver" {
  ami           = data.aws_ami.image.id
  instance_type = "t3.micro"
  tags = {
    Name = "httpdserver"
  }
}