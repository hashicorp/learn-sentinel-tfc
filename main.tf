terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.0.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.0.0"
    }
  }

  required_version = "~> 0.14"
  backend "remote" {
    organization = "hashicorp-rachel"
    workspaces {
      name = "sentinel-example"
    }
  }
}


provider "aws" {
  region = var.region
}


resource "random_pet" "petname" {
  length    = 3
  separator = "-"
}

resource "aws_s3_bucket" "demo" {
  bucket = "${var.prefix}-${random_pet.petname.id}"
  acl    = "public-read"
  tags = {
    Name        = "HashiCorp"
    Environment = "Learn"
  }
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.prefix}-${random_pet.petname.id}/*"
            ]
        }
    ]
}
EOF

  website {
    index_document = "index.html"
    error_document = "error.html"

  }
  force_destroy = true
}

resource "aws_s3_bucket_object" "demo" {
  acl          = "public-read"
  key          = "index.html"
  bucket       = aws_s3_bucket.demo.id
  content      = file("${path.module}/assets/index.html")
  content_type = "text/html"

}
