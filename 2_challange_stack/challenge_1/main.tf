terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# 1. Configuring the AWS Provider
provider "aws" {
  region = var.region
}


# 2. Creating a VPC.
resource "aws_vpc" "main" {
  cidr_block         = "10.0.0.0/16"
  enable_dns_support = var.dns_support

  tags = {
    "Name" = "Production VPC."
  }
}

# 3. Creating a subnet in the VPC
resource "aws_subnet" "web" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-west-1c"

  tags = {
    "Name" = "Web App Subnet"
  }
}

