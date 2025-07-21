
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.2.0"
    }
  }
}

provider "aws" {
  region = var.location
}

resource "aws_instance" "dbserver" {
  ami           = "ami-00c8ac9147e19828e"
  instance_type = "t3.micro"
  tags = {
    name = "dbserver-1"
  }
}


