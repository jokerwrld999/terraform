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
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.web_subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.custom_sec_group.id]
  key_name                    = aws_key_pair.generated_key.key_name

  #user_data = file("${var.entry_script_path}")

  tags = {
    Name = "${var.env_prefix}-server"
  }

}

# Custom Security Group
resource "aws_security_group" "custom_sec_group" {
  vpc_id = var.vpc_id

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
    Name = "${var.env_prefix}-custom-sg"
  }

}

# Creating SSH Key
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.ssh_key_name
  public_key = tls_private_key.private_key.public_key_openssh
}

resource "local_sensitive_file" "pem_file" {
  filename             = pathexpand("~/.ssh/${var.ssh_key_name}.pem")
  file_permission      = "600"
  directory_permission = "700"
  content              = tls_private_key.private_key.private_key_pem
}