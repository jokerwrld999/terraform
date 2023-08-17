# Creating a Subnet
resource "aws_subnet" "web_subnet" {
  vpc_id            = var.vpc_id
  cidr_block        = var.web_subnet
  availability_zone = var.subnet_zone

  tags = {
    Name = "${var.env_prefix}-subnet-1"
  }
}

# Creating an Intenet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env_prefix}-igw"
  }
}

# Creating a Route Table
resource "aws_route_table" "rt_web" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env_prefix}-main-rtb"
  }
}

#  Associating the IGW to the RT
resource "aws_route_table_association" "rt_web_association" {
  subnet_id      = aws_subnet.web_subnet.id
  route_table_id = aws_route_table.rt_web.id
}