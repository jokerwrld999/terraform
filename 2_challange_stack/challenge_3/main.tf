terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# !!Use your own access and secret keys!!
provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "server" {
  ami                         = var.my_ami["${var.aws_region}"]
  instance_type               = var.my_instance[0]
  count                       = var.my_instance[1]
  associate_public_ip_address = var.my_instance[2]
}

resource "aws_iam_user" "users" {
  for_each = toset(var.user_names)
  name  = each.value
}