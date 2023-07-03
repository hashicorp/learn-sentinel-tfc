provider "aws" {
  region = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ubuntu" {
  # Demo1
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type

  tags = {
    Name = var.instance_name
  }
  monitoring = true
}


resource "aws_security_group" "demo-sg" {
  # Demo1
  name = "demo-sg"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_iam_role" "iam_role" {
  # Demo1
  name               = var.iam_role_name
  assume_role_policy = <<EOF
{
  "Version": "20230704-001",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
#       "AWS": "*"
        type        = "Service"
        identifiers = ["ec2.amazonaws.com"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

#principal {
#      type        = "Service"
#      identifiers = ["ec2.amazonaws.com"]
#    }        
