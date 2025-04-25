# -------------------- VPC --------------------
resource "aws_vpc" "TF_VPC" {
  cidr_block = "10.0.0.0/20"
  tags = {
    Name = "cust_vpc"
  }
}

# -------------------- Subnets --------------------
resource "aws_subnet" "TF_Subnet_Pub" {
  vpc_id     = aws_vpc.TF_VPC.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "cust_subnet_pub"
  }
}

resource "aws_subnet" "TF_Subnet_Pvt1" {
  vpc_id     = aws_vpc.TF_VPC.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"  # Specify AZ for Private Subnet 1
  tags = {
    Name = "sub_pvt_1"
  }
}

resource "aws_subnet" "TF_Subnet_Pvt2" {
  vpc_id     = aws_vpc.TF_VPC.id
  cidr_block = "10.0.3.0/24"
    availability_zone = "us-east-1b"  # Specify AZ for Private Subnet 2
  tags = {
    Name = "sub_pvt_2"
  }
}

# -------------------- Internet Gateway --------------------
resource "aws_internet_gateway" "TF_IG" {
  vpc_id = aws_vpc.TF_VPC.id
  tags = {
    Name = "cust_IGW"
  }
}

# -------------------- Route Table --------------------
resource "aws_route_table" "TF_Pub_RT" {
  vpc_id = aws_vpc.TF_VPC.id  # ✅ FIXED: was aws.vpc.TF_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.TF_IG.id
  }

  tags = {
    Name = "cust_pub_RT"
  }
}

resource "aws_route_table_association" "TF_RT_assocation" {
  subnet_id      = aws_subnet.TF_Subnet_Pub.id
  route_table_id = aws_route_table.TF_Pub_RT.id
}

# -------------------- Security Group --------------------
resource "aws_security_group" "TF_SG" {
  vpc_id      = aws_vpc.TF_VPC.id
  name        = "cust_sg"
  description = "cust_sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/20"]  # 🔐 Recommended Change: limit to internal VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "TF_ec2" {
    ami = "ami-0e449927258d45bc4"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.TF_Subnet_Pub.id
    vpc_security_group_ids = [aws_security_group.TF_SG.id]
    key_name = "my-us-key"
    associate_public_ip_address = true  # Ensures EC2 gets a public IP
      
      tags = {
        Name = "cust_ec2"
    }
}