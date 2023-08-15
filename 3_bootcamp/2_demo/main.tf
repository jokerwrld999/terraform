provider "aws" {
  region = var.region
}

# Creating a Custom VPC
resource "aws_vpc" "custom_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "Custom VPC"
    env  = "Development"
  }
}

# Creating a Subnet
resource "aws_subnet" "web_subnet" {
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = var.web_subnet
  availability_zone = var.subnet_zone

  tags = {
    Name = "WebApp Subnet"
    env  = "Development"
  }
}

# Creating an Intenet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "Internet Gateway"
    env  = "Development"
  }
}

# Creating a Route Table
resource "aws_route_table" "rt_web" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "RT-Web"
    env  = "Development"
  }
}

#  Associating the IGW to the RT
resource "aws_route_table_association" "rt_web_association" {
  subnet_id      = aws_subnet.web_subnet.id
  route_table_id = aws_route_table.rt_web.id
}

# Get Latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Creating an EC2 Instance
resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.web_subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.custom_sec_group.id]
  key_name               = aws_key_pair.generated_key.key_name
  user_data              = <<-EOF
                    #!/bin/bash
                    # Install docker
                    sudo apt-get update
                    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
                    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
                    sudo add-apt-repository \
                       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
                       $(lsb_release -cs) \
                       stable"
                    sudo apt-get update
                    sudo apt-get install -y docker-ce
                    sudo usermod -aG docker ubuntu
                    sudo usermod -aG docker $USER
                    # Run Nginx Container
                    docker run --name nginx -d -p 80:80 nginx
                  EOF

  tags = {
    Name = "WebInstance"
  }
}

# Custom Security Group
resource "aws_security_group" "custom_sec_group" {
  vpc_id = aws_vpc.custom_vpc.id

  dynamic "ingress" {
    for_each = var.sg_ports.ports[*]
    content {


      from_port        = ingress.value.from
      to_port          = ingress.value.to
      protocol         = "tcp"
      cidr_blocks      = [ingress.value.source]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    "Name" = "Default Security Group"
  }
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.ssh_key_name
  public_key = tls_private_key.private_key.public_key_openssh
}

resource "local_sensitive_file" "pem_file" {
  filename = pathexpand("./${var.ssh_key_name}.pem")
  file_permission = "600"
  directory_permission = "700"
  content = tls_private_key.private_key.private_key_pem
}