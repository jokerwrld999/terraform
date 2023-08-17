variable "env_prefix" {
  description = "Environment Prefix"
  type        = string
}

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
  description = "Subnet Availability Zone"
  type        = string
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
}

variable "entry_script_path" {
  description = "User Data Entry Script Path"
  type        = string
}

variable "ssh_key_name" {
  description = "SSH Key Name"
  type        = string
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