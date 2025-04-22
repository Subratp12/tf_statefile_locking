# VPC
resource "aws_vpc" "VPC" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "Cust_VPC"
  }
}

# Subnets (Public & Private)
resource "aws_subnet" "subnets" {
  for_each          = var.subnet_cidrs
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = each.value
  availability_zone = var.availability_zones[each.key]

  tags = {
    Name = "${each.key}_Subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.VPC.id
  tags = {
    Name = "cust_IGW"
  }
}

# Elastic IP (For NAT Gateway)
resource "aws_eip" "EIP" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.IGW]
  tags = {
    Name = "Elastic_IP"
  }
}

# NAT Gateway (Placed in Public Subnet)
resource "aws_nat_gateway" "NATGW" {
  allocation_id = aws_eip.EIP.id
  subnet_id     = aws_subnet.subnets["public"].id
  tags = {
    Name = "NAT_Gateway"
  }
}

# Route Tables
resource "aws_route_table" "Public_RT" {
  vpc_id = aws_vpc.VPC.id
  tags = {
    Name = "Public_Route_Table"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
}

resource "aws_route_table" "Private_RT" {
  vpc_id = aws_vpc.VPC.id
  tags = {
    Name = "Private_Route_Table"
  }
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NATGW.id
  }
}

# Route Table Associations
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.subnets["public"].id
  route_table_id = aws_route_table.Public_RT.id
}

resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.subnets["private"].id
  route_table_id = aws_route_table.Private_RT.id
}

# Security Group (Allows SSH & All Outbound Traffic)
resource "aws_security_group" "TSG" {
  vpc_id = aws_vpc.VPC.id
  name   = "Test_SG"

  tags = {
    Name = "Test_SG"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict access to specific IP for better security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance (Public Subnet)
resource "aws_instance" "EC2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.subnets["public"].id
  vpc_security_group_ids = [aws_security_group.TSG.id]

  associate_public_ip_address = true # Ensures EC2 gets a public IP

  tags = {
    Name = "Public_EC2"
  }
}

# S3 Bucket
resource "aws_s3_bucket" "S3Bucket" {
  bucket = "subrat-terraform-bucket"
  tags = {
    Name = "S3Bucket"
  }
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "LogGroup" {
  name              = "subrat-log-group"
  retention_in_days = 1
  tags = {
    Name = "LogGroup"
  }
}