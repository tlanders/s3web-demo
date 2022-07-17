terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

# provider and region where resources will be created
provider "aws" {
  profile = "default"
  region = "us-east-1"
}

# resource to create redirect s3 bucket
resource "aws_s3_bucket" "redirect-bucket" {
  bucket = "lci-demo-bucket"

  tags = {
    name = "redirect to www demo bucket"
  }
}

resource "aws_s3_bucket_website_configuration" "s3-redirect-config" {
  bucket = aws_s3_bucket.redirect-bucket.bucket
  redirect_all_requests_to {
    host_name = aws_s3_bucket_website_configuration.s3-www-config.website_endpoint
    #protocol = "https"
  }
}

# resource to create www s3 bucket
resource "aws_s3_bucket" "www-bucket" {
  bucket = "www.lci-demo-bucket"

  tags = {
    name = "www demo bucket"
  }
}

# setup www bucket to host static web site
resource "aws_s3_bucket_website_configuration" "s3-www-config" {
  bucket = aws_s3_bucket.www-bucket.bucket
  index_document {
    suffix = "index.html"  
  }
  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_policy" "allow_public_access_bucket_policy" {
  bucket = aws_s3_bucket.www-bucket.id
  policy = data.aws_iam_policy_document.allow_public_access_doc.json
}

data "aws_iam_policy_document" "allow_public_access_doc" {
  statement {
    principals {
      type = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      aws_s3_bucket.www-bucket.arn,
      "${aws_s3_bucket.www-bucket.arn}/*"
    ]
  }
}
