provider "aws" {
  region = var.region
}

data "aws_availability_zones" "azs" {

}

module "myapp-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name            = "${var.app_name}-vpc"
  cidr            = var.vpc_cidr_block
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets  = var.public_subnet_cidr_blocks
  azs             = data.aws_availability_zones.azs.names

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernete.io/cluster/myapp-eks-cluster" = "shared"
  }

  public_subnet_tags = {
    "kubernete.io/cluster/myapp-eks-cluster" = "shared"
    "kubernetes.io/role/elb"                 = 1
  }

  private_subnet_tags = {
    "kubernete.io/cluster/myapp-eks-cluster" = "shared"
    "kubernetes.io/role/internale-elb"       = 1
  }
}