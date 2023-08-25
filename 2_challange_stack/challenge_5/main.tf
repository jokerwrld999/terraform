terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configuring the AWS Provider
# !!Use your own access and secret keys!!
provider "aws" {
  region = "us-west-1"
}


# Creating a new VPC
resource "aws_vpc" "production" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "Production VPC"
  }
}


# Creating a subnet in the VPC
resource "aws_subnet" "webapps" {
  vpc_id            = aws_vpc.production.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-west-1b"

  tags = {
    "Name" = "Web Applictations Subnet"
  }
}