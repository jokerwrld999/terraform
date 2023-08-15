terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~>4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "production" {
  cidr_block = "192.168.0.0/24"

  tags = {
    Name = "Production VPC"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.production.id
  cidr_block = var.public_subnet_cidrs

  tags = {
    Name = "Web Applications Subnet"
  }
}