terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.2.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_instance" "Servers" {
  ami           = "ami-0d03cb826412c6b0f"
  instance_type = "t3.micro"
  tags = {
    name = "Appserver-100"
  }
}

