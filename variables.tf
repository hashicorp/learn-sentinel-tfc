variable "region" {
  description = "AWS region"
  default = "us-west-1"
}

variable "instance_type" {
  description = "Type of EC2 instance to provision"
  default = "t2.nano"
}

variable "instance_name" {
  description = "EC2 instance name"
  default = "Provisioned by Terraform"
}

variable "iam_role_name" {
  description = "EC2 IAM role name"
  default = "permisive_iam_role"
}
