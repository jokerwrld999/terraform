variable "region" {
  description = "Region Name"
}

variable "vpc_cidr_block" {
  description = "VPC CIDR Block"
}

variable "private_subnet_cidr_blocks" {
  description = "Private Subnet CIDR Blocks"
}

variable "public_subnet_cidr_blocks" {
  description = "Public Subnet CIDR Blocks"
}

variable "environment" {
  description = "Environment Name"
}

variable "app_name" {
  description = "Application Name"
}