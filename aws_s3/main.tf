terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.2.0"
    }
     random = {
      source = "hashicorp/random"
      version = "3.7.2"
    }  

  }
}
provider "aws" {
  region = "ap-south-1"
}
resource "random_id" "s3" {
    byte_length = 5
}
resource "aws_s3_bucket" "demo-bucket" {
  bucket = "demo-bucket-${random_id.s3.hex}"
}

resource "aws_s3_object" "indexfile"{
    bucket = aws_s3_bucket.demo-bucket.bucket
    key = "index.html"
    source = "./index.html"
}


output "s3_name" {
  value = random_id.s3.hex
}


