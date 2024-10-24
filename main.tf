provider "aws" {
    region     = "us-east-1"
    
}

# VPC creation (not using the default VPC)
resource "aws_vpc" "frogtech_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name        = "FrogTechVPC"
    Environment = var.environment_tag
    Owner       = var.owner_tag
  }
}

# Internet Gateway for Internet access
resource "aws_internet_gateway" "frogtech_igw" {
  vpc_id = aws_vpc.frogtech_vpc.id
  tags = {
    Name        = "FrogTechIGW"
    Environment = var.environment_tag
    Owner       = var.owner_tag
  }
}

# Subnet creation
resource "aws_subnet" "frogtech_subnet" {
  vpc_id            = aws_vpc.frogtech_vpc.id
  cidr_block        = var.subnet_cidr
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags = {
    Name        = "FrogTechSubnet"
    Environment = var.environment_tag
    Owner       = var.owner_tag
  }
}

# Route Table for the subnet to connect to the Internet Gateway
resource "aws_route_table" "frogtech_route_table" {
  vpc_id = aws_vpc.frogtech_vpc.id
  tags = {
    Name        = "FrogTechRouteTable"
    Environment = var.environment_tag
    Owner       = var.owner_tag
  }
}

# Route for internet access
resource "aws_route" "frogtech_route" {
  route_table_id         = aws_route_table.frogtech_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.frogtech_igw.id
}

# Associate the subnet with the route table
resource "aws_route_table_association" "frogtech_route_table_association" {
  subnet_id      = aws_subnet.frogtech_subnet.id
  route_table_id = aws_route_table.frogtech_route_table.id
}

# Security group (optional, for allowing traffic)
resource "aws_security_group" "frogtech_sg" {
  vpc_id = aws_vpc.frogtech_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "FrogTechSecurityGroup"
    Environment = var.environment_tag
    Owner       = var.owner_tag
  }
}

# Output values
output "vpc_id" {
  value = aws_vpc.frogtech_vpc.id
}

output "subnet_id" {
  value = aws_subnet.frogtech_subnet.id
}

