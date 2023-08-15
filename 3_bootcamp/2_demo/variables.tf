variable "vpc_cidr_block" {
  description = "CIDR Block for the VPC"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "web_subnet" {
  description = "Web Subnet"
  type        = string
}

variable "subnet_zone" {

}

variable "ssh_key_name" {
  description = "SSH Key Name"
}

variable "sg_ports" {
  default = {
    ports = [
      {
        from   = 22
        to     = 22
        source = "0.0.0.0/0"
      },
      {
        from   = 80
        to     = 80
        source = "0.0.0.0/0"
      }
    ]
  }
}