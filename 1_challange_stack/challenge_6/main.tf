terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# !!Use your own access and secret keys!!
provider "aws"{
  region     = "us-west-1"

}

resource "aws_instance" "server" {
  ami = "ami-04a50faf2a2ec1901"
  instance_type = "t2.micro"
}