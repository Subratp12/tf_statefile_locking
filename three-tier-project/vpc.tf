#  Creation of VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "Custom-VPC-1"
  }
}

#  Creation of Public Subnets
resource "aws_subnet" "pub_1" {
  cidr_block              = var.public_subnets.pub_1
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public-subnet-1"
  }
}

resource "aws_subnet" "pub_2" {
  cidr_block              = var.public_subnets.pub_2
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public-subnet-2"
  }
}

#  Creation of Private Subnets
resource "aws_subnet" "pvt_1" {
  cidr_block        = var.private_subnets.pvt_1
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "ap-south-1a"
  tags = {
    Name = "FE-Private-subnet-1"
  }
}

resource "aws_subnet" "pvt_2" {
  cidr_block        = var.private_subnets.pvt_2
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "ap-south-1b"
  tags = {
    Name = "FE-Private-subnet-2"
  }
}

resource "aws_subnet" "pvt_3" {
  cidr_block        = var.private_subnets.pvt_3
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "ap-south-1a"
  tags = {
    Name = "BE-Private-subnet-3"
  }
}

resource "aws_subnet" "pvt_4" {
  cidr_block        = var.private_subnets.pvt_4
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "ap-south-1b"
  tags = {
    Name = "BE-Private-subnet-4"
  }
}

resource "aws_subnet" "pvt_5" {
  cidr_block        = var.private_subnets.pvt_5
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "ap-south-1a"
  tags = {
    Name = "RDS-Private-subnet-5"
  }
}

resource "aws_subnet" "pvt_6" {
  cidr_block = var.private_subnets.pvt_6

  vpc_id            = aws_vpc.vpc.id
  availability_zone = "ap-south-1b"
  tags = {
    Name = "RDS-Private-subnet-6"
  }
}

#  Creation of IG
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Cust-IGW"
  }
}

#  Creation of ELastic IP
resource "aws_eip" "eip" {
  domain = "vpc"
  tags = {
    Name = "NAT-EIP"
  }
}

#  Creation of NAT Gateway 
resource "aws_nat_gateway" "nat_1az" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.pub_1.id
  tags = {
    Name = "Cust NAT GW-1"
  }
  depends_on = [aws_internet_gateway.igw]

}


#  Creation of RT & Edit Routes
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table" "pvt_rt_1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1az.id
  }
  tags = {
    Name = "private-rt"
  }
}


#  Public Subnet association
resource "aws_route_table_association" "pub_sub_1" {
  subnet_id      = aws_subnet.pub_1.id
  route_table_id = aws_route_table.pub_rt.id
}

resource "aws_route_table_association" "pub_sub_2" {
  subnet_id      = aws_subnet.pub_2.id
  route_table_id = aws_route_table.pub_rt.id
}

#  Private Subnet association
resource "aws_route_table_association" "pvt_sub_1" {
  subnet_id      = aws_subnet.pvt_1.id
  route_table_id = aws_route_table.pvt_rt_1.id
}

resource "aws_route_table_association" "pvt_sub_2" {
  subnet_id      = aws_subnet.pvt_2.id
  route_table_id = aws_route_table.pvt_rt_1.id
}

resource "aws_route_table_association" "pvt_sub_3" {
  subnet_id      = aws_subnet.pvt_3.id
  route_table_id = aws_route_table.pvt_rt_1.id
}

resource "aws_route_table_association" "pvt_sub_4" {
  subnet_id      = aws_subnet.pvt_4.id
  route_table_id = aws_route_table.pvt_rt_1.id
}

resource "aws_route_table_association" "pvt_sub_5" {
  subnet_id      = aws_subnet.pvt_5.id
  route_table_id = aws_route_table.pvt_rt_1.id
}

resource "aws_route_table_association" "pvt_sub_6" {
  subnet_id      = aws_subnet.pvt_6.id
  route_table_id = aws_route_table.pvt_rt_1.id
}


# #  Creation of Public server
# resource "aws_instance" "pub_server-1" {
#     ami = var.ami
#     instance_type = var.instance_type
#     subnet_id = aws_subnet.pub_1.id
#     availability_zone = "ap-south-1a"
#     associate_public_ip_address = true
#     key_name = var.key_name
#     vpc_security_group_ids = [aws_security_group.sg.id]
#     tags = {
#       Name = "FE-Public_server"
#     }
# }

# resource "aws_instance" "pub_server-2" {
#     ami = var.ami
#     instance_type = var.instance_type
#     subnet_id = aws_subnet.pub_2.id
#     availability_zone = "ap-south-1b"
#     associate_public_ip_address = true
#     key_name = var.key_name
#     vpc_security_group_ids = [aws_security_group.sg.id]
#     tags = {
#       Name = "BE-Public_server"
#     }
# }
