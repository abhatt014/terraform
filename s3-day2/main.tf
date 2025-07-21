terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
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

resource "aws_s3_bucket" "gp" {
  bucket = "gp-bucket-${random_id.s3.hex}"
}

resource "aws_s3_object" "dummyfiles" {
    bucket = aws_s3_bucket.gp.bucket
    source = "./index.html"
    key = "index.html"
    content_type = "text/html"
    
}

output "bucket_id" {
  value = aws_s3_bucket.gp.id
}

