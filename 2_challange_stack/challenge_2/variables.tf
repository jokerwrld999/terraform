variable "aws_region" {
  type    = string
  default = "us-west-1"
}

variable "my_ami" {
  type = map(string)
  default = {
    "eu-central-1" = "ami-0dcc0ebde7b2e00db",
    "us-west-1"    = "ami-04a50faf2a2ec1901"
  }
}

variable "my_instance" {
  type    = tuple([string, number, bool])
  default = ["t2.micro", 2, true]
}