terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.2.0"
    }
  }
  backend "s3" {
    bucket = "gp-bucket-efe681394a"
    key = "terraform.tfstate"
    region = "ap-south-1"
     
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "Servers" {
  ami = "ami-0d03cb826412c6b0f"
  instance_type = "t3.micro"  
  tags = {
    name = "myserver"
  }
}

# https://<ur_s3_bucket_id>.s3-website.<region>.amazonaws.com