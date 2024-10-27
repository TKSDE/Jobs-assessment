# Create the VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

# Create Public Subnets
resource "aws_subnet" "public_subnets" {
  count                = length(var.public_subnets_cidr)
  vpc_id               = aws_vpc.main.id
  cidr_block           = var.public_subnets_cidr[count.index]
  map_public_ip_on_launch = true
  availability_zone    = element(var.azs, count.index)
  tags = {
    Name = "Public Subnet ${count.index}"
  }
}

# Create Private Subnets
resource "aws_subnet" "private_subnets" {
  count                = length(var.private_subnets_cidr)
  vpc_id               = aws_vpc.main.id
  cidr_block           = var.private_subnets_cidr[count.index]
  availability_zone    = element(var.azs, count.index)
  tags = {
    Name = "Private Subnet ${count.index}"
  }
}

# Create Internet Gateway for Public Subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# Route Table for Public Subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

# Associate Public Subnets with Route Table
resource "aws_route_table_association" "public_association" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# Security Group for RDS
resource "aws_security_group" "rds_sg" {
  name   = "rds-security-group"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "Allow MySQL inbound traffic"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Allowing traffic from within the VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-security-group"
  }
}

# Output for RDS Security Group ID
output "rds_security_group_id" {
  value = aws_security_group.rds_sg.id
}
