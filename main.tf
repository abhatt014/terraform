

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.2.0"
    }
    random = {
      source  = "hashicorp/random"
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


resource "aws_s3_bucket" "webapp" {
  bucket = "webapp-${random_id.s3.hex}"
}

resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.webapp.bucket
  source       = "./index.html"
  key          = "index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "style_css" {
  bucket       = aws_s3_bucket.webapp.bucket
  source       = "./style.css"
  key          = "style.css"
  content_type = "text/css"
}


resource "aws_s3_bucket_public_access_block" "webapp" {
  bucket                  = aws_s3_bucket.webapp.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_policy" "webapp" {
  bucket = aws_s3_bucket.webapp.id
  policy = jsonencode(
    {
      Version : "2012-10-17",
      Statement : [
        {
          Sid : "PublicReadGetObject",
          Effect : "Allow",
          Principal : "*",
          Action : "s3:GetObject",
          Resource : "${aws_s3_bucket.webapp.arn}/*" # Use .arn for clarity
        }
      ]
    }
  )
}

resource "aws_s3_bucket_website_configuration" "webapp" {
  bucket = aws_s3_bucket.webapp.id

  index_document {
    suffix = "index.html"
  }
}


output "website_url" {
  description = "The URL for the S3 static website"
  value       = aws_s3_bucket_website_configuration.webapp.website_endpoint
}