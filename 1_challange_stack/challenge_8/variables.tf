variable "vpc_cidr_block" {
    description = "CIDR Block for the VPC"
    type = string
}

variable "region" {
  description = "AWS Region"
  type = string
}

variable "web_subnet" {
    description = "Web Subnet"
    type = string
}

variable "subnet_zone" {
  
}

variable "main_vpc_name" {
  
}

variable "sg_ports" {
  default = {
    "server1" = {

      ports = [
        {
          from = 22
          to = 22
          source = "0.0.0.0/0"
        },
        {
          from = 80
          to = 80
          source = "0.0.0.0/0"
        }
      ]
    }
  }
}