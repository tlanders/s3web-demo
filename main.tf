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

# resource to create s3 bucket
resource "aws_s3_bucket" "demo-bucket" {
  bucket = "lci-demo-bucket"

  tags = {
    name = "S3Bucket"
  }
}

