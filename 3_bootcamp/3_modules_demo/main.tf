provider "aws" {
  region = var.region
}

# Creating a Custom VPC
resource "aws_vpc" "custom_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "${var.env_prefix}-vpc"
  }

}

module "myapp-subnet" {
  source      = "./modules/subnet"
  env_prefix = var.env_prefix
  vpc_id      = aws_vpc.custom_vpc.id
  web_subnet  = var.web_subnet
  subnet_zone = var.subnet_zone
}

module "myapp-webserver" {
  source            = "./modules/webserver"
  env_prefix = var.env_prefix
  vpc_id            = aws_vpc.custom_vpc.id
  instance_type     = var.instance_type
  web_subnet_id     = module.myapp-subnet.web_subnet_id
  sg_ports          = var.sg_ports
  entry_script_path = var.entry_script_path
  ssh_key_name      = var.ssh_key_name
}