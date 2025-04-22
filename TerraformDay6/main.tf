#VPC
resource "aws_vpc" "VPC" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Cust_VPC"
  }
}

#Subnet
resource "aws_subnet" "Subnet_Pub" {
  vpc_id            = aws_vpc.VPC.id
  availability_zone = "ap-south-2a"
  cidr_block        = "10.0.1.0/24"
  tags = {
    Name = "Public_Subnet_1"
  }
}

resource "aws_subnet" "Subnet_Pvt_1" {
  vpc_id            = aws_vpc.VPC.id
  availability_zone = "ap-south-2b"
  cidr_block        = "10.0.2.0/24"
  tags = {
    Name = "Pvt_Subnet_1"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.VPC.id
  tags = {
    Name = "cust_IGW"
  }
}
#NAT Gateway
resource "aws_nat_gateway" "NATGW" {
  allocation_id = aws_eip.EIP.id
  subnet_id     = aws_subnet.Subnet_Pub.id
  tags = {
    Name = "NAT_Gateway"
  }

}

#Elastic IP
resource "aws_eip" "EIP" {
  domain        = "vpc"
  depends_on = [aws_internet_gateway.IGW]
  tags = {
    Name = "Elastic_IP"
  }
}
#NAT Gateway Route Table
resource "aws_route_table" "NAT_RT" {
  vpc_id = aws_vpc.VPC.id
  tags = {
    Name = "NAT_Route_Table"
  }
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NATGW.id
  }
  
}

#Route Table Association
resource "aws_route_table_association" "Pvt_RTA" {
  subnet_id      = aws_subnet.Subnet_Pvt_1.id
  route_table_id = aws_route_table.NAT_RT.id

}

#Public Route Table
resource "aws_route_table" "Pub_RT" {
  vpc_id = aws_vpc.VPC.id

  tags = {
    Name = "Public_Route_Table"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id

  }
}


#Route Table Association
resource "aws_route_table_association" "RTA" {
  subnet_id      = aws_subnet.Subnet_Pub.id
  route_table_id = aws_route_table.Pub_RT.id

}


#Security Group 
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
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#EC2 Instance
resource "aws_instance" "EC2" {
  ami                    = "ami-05cef57fad40b2755"
  instance_type          = "t3.micro"
  key_name               = "AWS_hyd"
  subnet_id              = aws_subnet.Subnet_Pub.id
  vpc_security_group_ids = [aws_security_group.TSG.id]
  associate_public_ip_address = true
  tags = {
    Name = "SP"
  }

}

# Private EC2 Instance
resource "aws_instance" "EC2_Private" {
  ami                    = "ami-05cef57fad40b2755"
  instance_type          = "t3.micro"
  key_name               = "AWS_hyd"
  subnet_id              = aws_subnet.Subnet_Pvt_1.id  
  vpc_security_group_ids = [aws_security_group.TSG.id]

  tags = {
    Name = "Private_SP"
  }
}

#S3 Bucket
resource "aws_s3_bucket" "S3Bucket" {
  bucket = "subrat-terraform-bucket"
  tags = {
    Name = "S3Bucket"
  }
}

#CloudWatch Log Group
resource "aws_cloudwatch_log_group" "LogGroup" {
  name              = "subrat-log-group"
  retention_in_days = 14
  tags = {
    Name = "LogGroup"
  }
}